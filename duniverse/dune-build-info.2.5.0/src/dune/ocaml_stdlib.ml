type t =
  { modules_before_stdlib : Module_name.Set.t
  ; exit_module : Module_name.t option
  ; internal_modules : Glob.t
  }

let syntax =
  let syntax =
    Dune_lang.Syntax.create
      ~name:"experimental_building_ocaml_compiler_with_dune"
      ~desc:"experimental feature for building the compiler with dune"
      [ ((0, 1), `Since (1, 3)) ]
  in
  Dune_project.Extension.register_simple ~experimental:true syntax
    (Dune_lang.Decoder.return []);
  syntax

let decode =
  let open Dune_lang.Decoder in
  fields
    (let+ modules_before_stdlib =
       field "modules_before_stdlib" (repeat Module_name.decode) ~default:[]
     and+ exit_module = field_o "exit_module" Module_name.decode
     and+ internal_modules =
       field "internal_modules" Glob.decode ~default:Glob.empty
     in
     { modules_before_stdlib = Module_name.Set.of_list modules_before_stdlib
     ; exit_module
     ; internal_modules
     })