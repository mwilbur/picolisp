# 04sep04abu
# (c) Software Lab. Alexander Burger

# *Sock *Panel

(load "lib/xterm.l")
(load "rcsim/lib.l")


(de main ()
   (setq
      *Pilot (new '(+Pilot))
      *Scene (new '(+Scene))
      *Model (new '(+Model))
      *Panel (list
         0 " %  "
         0 " km/h  "
         0 " m/s  "
         0 " m  "
         NIL ) )
   (?push '*Bye '(tone> *Scene 0 0)) )

(de setPanel (N X)
   (set (nth *Panel N) X)
   (prinl *Panel) )

(de go ()
   (out (setq *Sock (listen (port 8080) 120000))
      (pr 600 400) )
   (start)
   (draw)
   (task *Sock
      (in *Sock
         (case (rd)
            (`(char "o")  # ok
               (draw) )
            (`(char "c")  # clk
               (rd) (rd) ) ) ) ) )

# Key Controls
(fkey *XtUp
   (down> *Model) )

(fkey *XtDown
   (up> *Model) )

(fkey *XtLeft
   (left> *Model) )

(fkey *XtRight
   (right> *Model) )

(fkey *XtHome
   (throt> *Model T) )

(fkey *XtPgDn
   (throt> *Model -1) )

(fkey *XtPgUp
   (throt> *Model +1) )

(fkey *XtEnd
   (throt> *Model) )


# Pilot
(class +Pilot)

(dm thr> (N)
   (setPanel 1 N) )

(dm speed> (N)
   (setPanel 3 N) )

(dm climb> (N)
   (setPanel 5 N) )

(dm alt> (N)
   (setPanel 7 N) )

(dm rate> (N)
   (setPanel 9 (pack (format N 2) " s")) )


# Scene
(class +Scene)
# env tone

(dm T ()
   (load "rcsim/env.l")
   (when (call "test" "-p" "fifo/tone")
      (=: tone (open "fifo/tone")) ) )

(dm sim> ())

(dm draw> ()
   (out *Sock
      (let Dir (dir> *Model)
         (z3d:Draw 7500.0 (car Dir) (cdr Dir)  0 0 *Tower  LightBlue DarkGreen)
         (z3d:Draw (get *Model 'body))
         (mapc z3d:Draw (: env))
         (z3d:Draw) ) ) )

(dm tone> (A F)
   (when (: tone)
      (out @ (pr A F)) ) )