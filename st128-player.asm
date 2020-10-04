key     equ     0
ton     equ     2
laut    equ     4
vsdau   equ     5
hflg    equ     6
anfa    equ     7
vol     equ     8
vscnt   equ     9
vsdir   equ     10
nobit   equ     11
arpe    equ     12
ent     equ     14
env     equ     16
enn     equ     18
repe    equ     20
rlen    equ     21
rpos    equ     22
goo     equ     23
arpt1   equ     24
arpt2   equ     25
arcnt   equ     26
        ;27 ist leer
pstep   equ     28
pdau    equ     30
pcnt    equ     31
ein     equ     56
song    equ     #5000
        ;
        org     #9000
        jp      init
        jp      play
        jp      rstop



init    ld      hl,song
        ld      (inst+1),hl
        ld      de,#820
        add     hl,de
        ld      (arpanf+1),hl
        ld      de,#210
        add     hl,de
        ld      (ptab+1),hl
        ld      de,#0e8
        add     hl,de
        ld      (htab+1),hl
        ld      de,#068
        add     hl,de
        ld      (pbase+1),hl
        dec     hl
        ld      (basf+1),hl
        dec     hl
        ld      (base+1),hl
        dec     hl
        ld      (basd+1),hl
        ld      a,(hl)
        ld      e,a
        ld      (down),a
        dec     hl
        ld      (basc+1),hl
        dec     hl
        ld      (basb+1),hl
        ld      a,(hl)
        ld      (tempo),a
        ld      d,0
        ld      h,d
        ld      l,e
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,de
        ld      (plen),hl
        ld      hl,-1
        ld      (oldreg),hl
        ld      (oldreg+2),hl
        xor     a
        ld      ix,tona
        call    reset
        ld      ix,tonb
        call    reset
        ld      ix,tonc
        call    reset
        ld      (ppos),a
        call    getp
basb    ld      a,(0)
        ld      (dly),a
        ld      a,ein
        ld      (reg7),a
        jp      play1
reset   ld      (ix+arpe+1),a
        ld      (ix+hflg),a
        ld      (ix+rlen),a
        ld      (ix+goo),a
        ret

play    ld      ix,tona
        call    playe
        ld      ix,tonb
        call    playe
        ld      ix,tonc
        call    playe
        ;
        ld      hl,oldreg
        ld      a,(reg6)
        cp      (hl)
        jr      z,cont1
        ld      (hl),a
        ld      c,a
        ld      a,6
        call    reg
cont1   ld      a,(reg7)
        inc     hl
        cp      (hl)
        jr      z,cont2
        ld      (hl),a
        ld      c,a
        ld      a,7
        call    reg
cont2   ld      a,(reg11)
        inc     hl
        cp      (hl)
        jr      z,cont3
        ld      (hl),a
        ld      c,a
        ld      a,11
        call    reg
cont3   ld      a,(reg13)
        inc     hl
        cp      (hl)
        jr      z,cont4
        ld      (hl),a
        ld      c,a
        ld      a,13
        call    reg
cont4   ld      hl,dly
        dec     (hl)
        ret     nz
        ld      a,(tempo)
        ld      (hl),a
play1   ld      ix,tona
        ld      e,0
        call    pla1
        ld      ix,tonb
        ld      e,3
        call    pla1
        ld      ix,tonc
        ld      e,6
        call    pla1
        ;
        ld      hl,(padr)
        ld      de,9
        add     hl,de
        ld      (padr),hl
        ld      hl,down
        dec     (hl)
        ret     nz
basd    ld      a,(0)
        ld      (hl),a
        ld      a,(ppos)
        inc     a
basf    ld      hl,0
        cp      (hl)
        jr      nz,play2
basc    ld      a,(0)
play2   ld      (ppos),a
        ;
getp    ld      d,0
        ld      e,a
        push    de
ptab    ld      hl,0
        add     hl,de
        ld      a,(hl)
pbase   ld      hl,0
        ld      de,(plen)
        or      a
        jr      z,nomul
mult    add     hl,de
        dec     a
        jr      nz,mult
nomul   ld      (padr),hl
        pop     de
htab    ld      hl,0
        add     hl,de
        ld      a,(hl)
        ld      (path+1),a
        ret
        ;
pla1    xor     a
        ld      i,a
        ld      (ix+pdau),a
        ld      (ix+vsdir),a
        dec     a
        ld      (ix+arcnt),a
        ld      hl,(padr)
        ld      d,0
        add     hl,de
        ld      a,(hl)
        inc     hl
        cp      #d0
        jp      z,lpause
        or      a
        jr      z,efcmd
        ld      c,a
        rrca
        rrca
        rrca
        rrca
        and     15
        ld      b,a
        ld      a,c
        and     15
        dec     a
        add     a,a
        add     a,a
        ld      c,a
        add     a,a
        add     a,c
        add     a,b
        dec     a
        ld      i,a
        ld      a,(hl)
        rrca
        rrca
        rrca
        rrca
        ; A=Inst#
        push    hl
        call    getins
        ld      bc,32
        ld      (ix+env),l
        ld      (ix+env+1),h
        add     hl,bc
        ld      (ix+enn),l
        ld      (ix+enn+1),h
        add     hl,bc
        ld      (ix+ent),l
        ld      (ix+ent+1),h
        add     hl,bc
        add     hl,bc
        ld      a,(hl)
        ld      (ix+repe),a
        inc     hl
        ld      a,(hl)
        ld      (ix+rlen),a
        ld      (ix+rpos),0
        ld      (ix+goo),32
        pop     hl
        ld      (ix+vol),0
efcmd   ld      a,(hl)
        inc     hl
        push    hl
        and     15
        add     a,a
        ld      d,0
        ld      e,a
        ld      hl,exec
        add     hl,de
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        pop     hl
        call    jpde
        ld      a,i
        or      a
        ret     z
base    ld      hl,0
        add     a,(hl)
path    add     a,0
        ld      (ix+anfa),a
        add     a,a
        ld      d,0
        ld      e,a
        ld      hl,notab
        add     hl,de
        ld      c,(hl)
        ld      (ix+key),c
        inc     hl
        ld      c,(hl)
        ld      (ix+key+1),c
        ret
jpde    push    de
        ret
lpause   xor     a
        ld      (ix+goo),a
        ld      (ix+rlen),a
        ld      c,a
        ld      a,(ix+laut)
        jp      reg
        ;
sharp   ld      a,(hl)
        or      a
        ret     z
        ld      c,a
        rrca
        rrca
        rrca
        rrca
        and     15
        ld      (ix+arpt1),a
        ld      a,c
        and     15
        ld      (ix+arpt2),a
        ld      (ix+arcnt),0
        ret
offa    xor     a
        ld      (ix+arpe+1),a
        ld      (ix+hflg),a
        ret
portu   ld      a,(hl)
        ld      c,a
        and     15
        ret     z
        ld      b,0
        jr      porta2
portd   ld      a,(hl)
        ld      c,a
        and     15
        ret     z
        neg
        ld      b,-1
porta2  ld      (ix+pstep),a
        ld      (ix+pstep+1),b
        ld      a,c
        rrca
        rrca
        rrca
        rrca
        and     15
        ret     z
        ld      (ix+pdau),a
        ld      (ix+pcnt),a
        ret
volup   ld      a,(hl)
        ld      (ix+vsdau),a
        ld      (ix+vscnt),a
        ld      (ix+vsdir),-1
        ret
voldn   ld      a,(hl)
        ld      (ix+vsdau),a
        ld      (ix+vscnt),a
        ld      (ix+vsdir),1
        ret
arpvol  ld      a,(hl)
        ld      c,a
        and     15
        ld      b,a
        ld      a,15
        sub     b
        ld      (ix+vol),a
        ld      a,c
        rrca
        rrca
        rrca
        rrca
        jp      arp1
harde   dec     hl
        ld      a,(hl)
        ld      (reg13),a
        inc     hl
        ld      a,(hl)
        ld      (reg11),a
        xor     a
        ld      (ix+arpe+1),a
        ld      (ix+hflg),16
        ret
break   ld      a,1
        ld      (down),a
        ret
maxv    ld      a,(hl)
        and     15
        ld      b,a
        ld      a,15
        sub     b
        ld      (ix+vol),a
        ret
usenv   ld      a,(hl)
        ld      c,a
        rrca
        rrca
        rrca
        rrca
        call    getins
        ld      de,32
        add     hl,de
        ld      (ix+enn),l
        ld      (ix+enn+1),h
        ld      a,c
        call    getins
        ld      de,64
        add     hl,de
        ld      (ix+ent),l
        ld      (ix+ent+1),h
        ret
dey     ld      a,(hl)
        and     63
        cp      2
        ret     c
        ld      (tempo),a
        ld      (dly),a
        ret
posjp   ld      a,(hl)
        and     31
        ld      (ix+rpos),a
        ld      b,a
        ld      a,32
        sub     b
        ld      (ix+goo),a
        ret
arp     ld      a,(hl)
arp1    and     15
        add     a,a
        add     a,a
        add     a,a
        add     a,a
        ld      h,0
        ld      l,a
        add     hl,hl
arpanf  ld      de,0
        add     hl,de
        ld      (ix+arpe),l
        ld      (ix+arpe+1),h
        ld      (ix+hflg),0
        ret
        ;
dummy   ret
        ;
getins  and     15
        add     a,a
        ld      d,0
        ld      e,a
        add     a,a
        add     a,a
        add     a,a
        ld      h,d
        ld      l,a
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,de
inst    ld      de,0
        add     hl,de
        ret
        ;
playe   ld      a,(ix+goo)
        or      a
        jr      nz,dach
        ld      a,(ix+rlen)
        or      a
        ret     z
        ld      (ix+goo),a
        ld      a,(ix+repe)
        ld      (ix+rpos),a
dach    ld      d,0
        ld      e,(ix+rpos)
        inc     (ix+rpos)
        dec     (ix+goo)
        ;
        ; Arpeggio 0xx and Fxx
        ;
        ld      a,(ix+arpe+1)
        or      a
        jr      nz,puff
        ld      a,(ix+arcnt)
        cp      -1
        jp      z,not0
        ld      c,a
        inc     a
        cp      3
        jr      nz,haus
        xor     a
haus    ld      (ix+arcnt),a
        ld      a,c
        or      a
        jr      z,kaff
        ld      a,(ix+arpt1)
        dec     c
        jr      z,kaff
        ld      a,(ix+arpt2)
        jr      kaff
puff    ld      h,a
        ld      l,(ix+arpe)
        add     hl,de
        ld      a,(hl)
kaff    ld      b,(ix+anfa)
        add     a,b
        add     a,a
        ld      b,0
        ld      c,a
        ld      hl,notab
        add     hl,bc
        ld      a,(hl)
        ld      (ix+key),a
        inc     hl
        ld      a,(hl)
        ld      (ix+key+1),a
        ;
        ; Tone-Envelope
        ; Portamentos
        ;
not0    ld      l,(ix+key)
        ld      h,(ix+key+1)
        push    hl
        ld      a,(ix+pdau)
        or      a
        jr      z,nopo
        dec     (ix+pcnt)
        jr      nz,nopo
        ld      a,(ix+pdau)
        ld      (ix+pcnt),a
        ld      c,(ix+pstep)
        ld      b,(ix+pstep+1)
        add     hl,bc
        ld      (ix+key),l
        ld      (ix+key+1),h
        ex      (sp),hl
nopo    ld      h,(ix+ent+1)
        ld      l,(ix+ent)
        add     hl,de
        add     hl,de
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        pop     hl
        add     hl,bc
        ld      c,l
        ld      a,(ix+ton)
        call    reg
        ld      c,h
        ld      a,(ix+ton+1)
        call    reg
        ;
        ; Volume-Envelope
        ; Max.Volume Set
        ; Volume-Slide
        ; Hard-Envelope
        ;
        ld      h,(ix+env+1)
        ld      l,(ix+env)
        add     hl,de
        ld      a,(hl)
lend    bit     7,a
        jr      nz,not2
        and     15
        ld      b,a
        dec     (ix+vscnt)
        jr      nz,nosli
        ld      a,(ix+vsdau)
        ld      (ix+vscnt),a
        ld      a,(ix+vol)
        add     a,(ix+vsdir)
        jp      p,luke
        xor     a
        jr      lake
luke    cp      16
        jr      nz,lake
        dec     a
lake    ld      (ix+vol),a
nosli   ld      a,b
        sub     (ix+vol)
        jr      nc,lunt
        xor     a
lunt    or      (ix+hflg)
        ld      c,a
        ld      a,(ix+laut)
        call    reg
        ;
        ; Noise-Envelope
        ; Noise-Priority-Check
        ; Reg7 calculation
        ;
        ;
not2    ld      l,(ix+enn)
        ld      h,(ix+enn+1)
        add     hl,de
        ld      a,(hl)
        bit     7,a
        ret     nz
        and     31
        ld      b,(ix+nobit)
        ld      c,a
        or      a
        ld      a,b
        jr      z,woff
        ld      b,a
        ld      a,c
        ld      (reg6),a
        ld      a,b
        sub     64
woff    ld      (steb+1),a
        ld      a,(reg7)
steb    bit     0,a
        ld      (reg7),a
        ret
rstop    ld      a,8
        ld      c,0
        call    reg
        ld      a,9
        ld      c,0
        call    reg
        ld      a,10
        ld      c,0
        ;
reg     di
        ld      b,#f4
        out     (c),a
        ld      b,#f6
        in      a,(c)
        or      #c0
        out     (c),a
        and     #3f
        out     (c),a
        ld      b,#f4
        out     (c),c
        ld      b,#f6
        ld      c,a
        or      #80
        out     (c),a
        out     (c),c
        ei
        ret
dly     defb    0
down    defb    0
ppos    defb    0
reg6    defb    0
reg7    defb    ein
reg11   defb    0
reg13   defb    0
tempo   defb    0
padr    defw    0
plen    defw    0
oldreg  defs    4
        ;
exec    defw    sharp,offa,portu,portd,voldn,volup
        defw    arpvol,dummy,harde,break,harde,maxv
        defw    usenv,dey,posjp,arp
notab   
        defw    3822,3608,3405,3214,3034,2863
        defw    2703,2551,2408,2273,2145,2025
        defw    1911,1804,1703,1607,1517,1432
        defw    1351,1276,1204,1136,1073,1012
        defw    956,902,851,804,758,716
        defw    676,638,602,568,536,506
        defw    478,451,426,402,379,358
        defw    338,319,301,284,268,253
        defw    239,225,213,201,190,179
        defw    169,159,150,142,134,127
        defw    119,113,106,100,95,89
        defw    84,80,75,71,67,63
        defw    60,56,53,50,47,45
        defw    42,40,38,36,34,32
        defw    30,28,27,25,24,22
        defw    21,20,19,18,17,16
        defw    15,0,0
        ;
tona    defw    0; Periode
        defb    0,1     ; Per.Reg.#
        defb    8,0; Vol.Reg.#
        defb    0
        defw    0
        defb    0,0; Volslide
        defb    #df
        defw    0
        defw    #1080,#14a0,#16b0
        defb    0,32,0,0
        defb    0,0,0; Arpeggio
        defb    0
        defw    0
        defb    0,0; Portamento
        ;
tonb    defw    0
        defb    2,3
        defb    9,0
        defb    0
        defw    0
        defb    0,0
        defb    #e7
        defw    0
        defw    #1080,#14a0,#16b0
        defb    0,32,0,0
        defb    0,0,0
        defb    0
        defw    0
        defb    0,0
        ;
tonc    defw    0
        defb    4,5
        defb    10,0
        defb    0
        defw    0
        defb    0,0
        defb    #ef
        defw    0
        defw    #1080,#14a0,#16b0
        defb    0,32,0,0
        defb    0,0,0
        defb    0
        defw    0
        defb    0,0
        ;
