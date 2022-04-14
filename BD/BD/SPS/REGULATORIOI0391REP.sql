-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOI0391REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOI0391REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOI0391REP`(
/************************************************************************
---- SP QUE GENRA LA LLAMADA AL REGULATORIO I0391                   -----
************************************************************************/
    Par_Anio            INT,		-- Ano del reporte
    Par_Mes             INT, 		-- Mes del reporte
	Par_NumRep		    TINYINT UNSIGNED, -- Tipo de Reporte

	Aud_Empresa		    INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN
-- Variables
	DECLARE Var_Periodo 		VARCHAR(8);		-- Periodo del reporte
	DECLARE Var_ClaveEntidad 	VARCHAR(10); 	-- Clave de la entidad
	DECLARE Var_NumCliente		INT; 			-- Numero de Cliente
	DECLARE Var_TipoInsti		INT; 			-- Tipo de Institucion
	DECLARE Var_EsEspecial		CHAR(1); 		-- Define si un SP es especial para un cliente
	DECLARE Var_NumCliReg		VARCHAR(3); 	-- Valor por defecto del Cliente Regulatorio
	DECLARE Var_NombreReporte	VARCHAR(29); 	-- Nombre del Reporte
	DECLARE Var_llamada 		VARCHAR(400);

	-- Constantes
	DECLARE NumReporte			VARCHAR(7);
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia 		VARCHAR(2);
	DECLARE Resp_SI 			CHAR(1);
	DECLARE Resp_NO 			CHAR(1);
   	DECLARE Con_CliProcEspe     VARCHAR(20);
   	DECLARE Con_TipoRegula      VARCHAR(20);

	SET NumReporte			:= 'I0391';				-- Clave del reporte
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia 		:= '';
	SET Con_CliProcEspe     := 'CliProcEspecifico';	-- Llave para obtener el numero del cliente
	SET Con_TipoRegula    	:= 'TipoRegulatorios';  -- llave para obtener el Tipo de Regulatorios
	SET Var_NumCliReg		:= '000'; 				-- Valor DEFAULT para la llamada del regulatorio
	SET Resp_SI				:= 'S';
	SET Resp_SI				:= 'N';

	-- Numero del Cliente
	SELECT IFNULL(ValorParametro, Entero_Cero)
		INTO 	Var_NumCliente
		FROM 	PARAMGENERALES
		WHERE 	LlaveParametro = Con_CliProcEspe;

	-- Tipo de Regulatorios
	SELECT IFNULL(ValorParametro, Entero_Cero)
		INTO 	Var_TipoInsti
		FROM 	PARAMGENERALES
		WHERE 	LlaveParametro = Con_TipoRegula;

	SELECT CASE WHEN FIND_IN_SET(Var_NumCliente,Ins.Especiales) > Entero_Cero THEN Resp_SI ELSE Resp_NO END
		INTO 	Var_EsEspecial
		FROM 	REGULATORIOSINS Ins
        WHERE 	Clave = NumReporte;

	IF(Var_EsEspecial = Resp_SI) THEN
		SET Var_NumCliReg := LPAD(Var_NumCliente,3,Entero_Cero);
	END IF;

	SET Var_NombreReporte := CONCAT('REG', NumReporte,Var_NumCliReg,LPAD(Var_TipoInsti,2,Entero_Cero),'REP');

	SET Var_Llamada := CONCAT(' CALL ',Var_NombreReporte,
		'(',Par_Anio,',',Par_Mes,',',Var_TipoInsti,',',Par_NumRep,',',Aud_Empresa,',',Aud_Usuario,',',"'",Aud_FechaActual,"'",',',"'",Aud_DireccionIP,"'",',',"'",Aud_ProgramaID,"'",',',Aud_Sucursal,',',Aud_NumTransaccion,');');


	SET @Sentencia    = (Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;

END TerminaStore$$