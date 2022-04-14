-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANCEINTERNOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANCEINTERNOREP`;DELIMITER $$

CREATE PROCEDURE `BALANCEINTERNOREP`(
    Par_Ejercicio       int,
    Par_Periodo         int,
    Par_Fecha           date,
    Par_TipoConsulta    char(1),
    Par_SaldosCero      char(1),

    Par_Cifras          char(1),
    Par_CCInicial       int,
    Par_CCFinal         int,
    Par_EmpresaID       int,
    Aud_Usuario         int,

    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
)
TerminaStore: BEGIN


DECLARE Entero_Cero    		int;
DECLARE Con_Uno    			int;
DECLARE Con_Dos    			int;
DECLARE Con_Tres 			int;
DECLARE Con_Cuatro 			int;
DECLARE Con_Cinco  			int;
DECLARE Con_Seis 			int;
DECLARE Con_Siete    		int;
DECLARE Con_Ocho   			int;
DECLARE Con_Nueve  			int;
DECLARE Con_Diez 			int;
DECLARE Con_Once    		int;
DECLARE Con_Doce   			int;
DECLARE Con_Trece  			int;
DECLARE Con_Catorce    		int;
DECLARE Con_BalanceGeneral 	int;
DECLARE Con_CliProcEspe     varchar(20);
DECLARE Par_Salida			char(1);
DECLARE	Par_NumErr			int;
DECLARE Par_ErrMen			varchar(350);
DECLARE SalidaSI            char(1);
DECLARE SalidaNO			char(1);


DECLARE Var_CliProEsp   		int;
DECLARE Var_llamada 			varchar(400);
DECLARE Var_ProcPersonalizado 	varchar(200);
DECLARE Var_Control 	   		char(15);


Set Entero_Cero 		:= 0;
Set Con_Uno    			:= 1;
Set Con_Dos    			:= 2;
Set Con_Tres 			:= 3;
Set Con_Cuatro 			:= 4;
Set Con_Cinco  			:= 5;
Set Con_Seis 			:= 6;
Set Con_Siete  			:= 7;
Set Con_Ocho   			:= 8;
Set Con_Nueve  			:= 9;
Set Con_Diez 			:= 10;
Set Con_Once   			:= 11;
Set Con_Doce   			:= 12;
Set Con_Trece  			:= 13;
Set Con_Catorce			:= 14;
Set Con_BalanceGeneral	:= 1;
Set Con_CliProcEspe     := 'CliProcEspecifico';
Set SalidaSI        	:= 'S';
Set SalidaNO        	:= 'N';
Set Par_NumErr  		:= 0;
Set Par_ErrMen  		:= '';


ManejoErrores:BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := '999';
					SET Par_ErrMen := concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
											 'estamos trabajando para resolverla. Disculpe las molestias que ',
											 'esto le ocasiona. Ref: SP-BALANCEINTERNOREP');
					SET Var_Control = 'sqlException' ;
				END;



select ifnull(ValorParametro, Entero_Cero)   into Var_CliProEsp
    from PARAMGENERALES
    where    LlaveParametro = Con_CliProcEspe;


set Var_ProcPersonalizado:=(Select NomProc
from CATPROCEDIMIENTOS
where ProcedimientoID = Con_BalanceGeneral
  and	CliProEspID = Var_CliProEsp);

Set Var_Llamada := concat(' CALL ', Var_ProcPersonalizado,' (',Par_Ejercicio,',',Par_Periodo,',',"'",Par_Fecha,"'",",","'",Par_TipoConsulta,"'",",","'",Par_SaldosCero,"'",",","'",Par_Cifras,"'",",",Par_CCInicial,",",Par_CCFinal,",",Par_EmpresaID,",",Aud_Usuario,",","'",Aud_FechaActual,"'",",","'",Aud_DireccionIP,"'",",","'",Aud_ProgramaID,"'",",","'",Aud_Sucursal,"'",",","'",Aud_NumTransaccion,"'",");");


SET @Sentencia    = (Var_Llamada);
PREPARE EjecutaProc FROM @Sentencia;
EXECUTE  EjecutaProc;
DEALLOCATE PREPARE EjecutaProc;

END ManejoErrores;


END TerminaStore$$