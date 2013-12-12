module Cakefile where

import Development.Cake3
import Development.Cake3.Ext.UrWeb
import Cakefile_P

instance IsString File where fromString = file

project = do

  u <- uwlib "lib.urp" $ do
    ur (single "state.ur")

  apps <- forM ["Test1.ur", "Test2.ur", "Test3.ur", "Test4.ur"] $ \f -> do
    let src = (file $ "test"</> f)
    uwapp "-dbms sqlite" (src.="urp") $ do
      library u
      ur (sys "option")
      ur (single src)
      debug

  rule $ do
    phony "run"
    shell [cmd|$(last apps)|]

  rule $ do
    phony "clean"
    unsafeShell [cmd|rm -rf .cake3 $(map tempfiles apps)|]

  rule $ do
    phony "all"
    depend u
    depend apps

main = do
  writeMake (file "Makefile") (project)
  writeMake (file "Makefile.devel") (selfUpdate >> project)

