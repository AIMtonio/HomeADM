-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCPRINCIPALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCPRINCIPALPRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTATDCPRINCIPALPRO`(
	Par_DiaCorte 			INT,			-- Dia del corte del un tarjeta
	Par_Periodo       		INT,			-- Periodo de inicio a fecha de corte de una tarjeta
	Par_EmpresaID			INT,			-- Parametro de Auditoria
	Aud_Usuario				INT,			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT,			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT			-- Parametro de Auditoria
)

TerminaStore: BEGIN

DECLARE Var_FechaSistema   	DATE;
DECLARE Var_FecIniCorte   	DATE;
DECLARE Var_FecFinCorte  	DATE;
DECLARE Var_ClienteInstitu  INT(11);

SET Var_ClienteInstitu  	:= 	1;


SELECT FechaSistema
INTO Var_FechaSistema
FROM PARAMETROSSIS;

SET Var_FecFinCorte				:=	DATE(CONCAT(CAST(Par_Periodo AS CHAR), CAST(LPAD(Par_DiaCorte,2,'0') AS CHAR)));
	-- Se calcula 1 mes hacia atras y se almacena en la variabale de fcha de inicio
SET	Var_FecIniCorte			:= DATE_ADD(Var_FecFinCorte,INTERVAL -1 MONTH);

	-- Una vez posicionado un mes atras, se suma un dia, todo sobre la variable Fecha de Inicio
SET	Var_FecIniCorte			:= DATE_ADD(Var_FecIniCorte,INTERVAL 1 DAY);



TRUNCATE TABLE EDOCTATDCLINEACRED;
TRUNCATE TABLE EDOCTATDCDATOSCTE;
TRUNCATE TABLE EDOCTATDCRESUMMOV;
TRUNCATE TABLE EDOCTATDCTASASINT;
TRUNCATE TABLE EDOCTATDCDETMOVMXGRAL;
TRUNCATE TABLE EDOCTATDCDETMOVEXGRAL;
TRUNCATE TABLE EDOCTATDCACLARACIONES;

CALL EDOCTATDCLINEACREDPRO(	Par_DiaCorte,				Par_Periodo,			Var_FecIniCorte,		Var_FecFinCorte,		Par_EmpresaID,
														Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
														Aud_NumTransaccion
													);

CALL EDOCTATDCDATOSCTEPRO(	Par_DiaCorte,				Par_Periodo,			Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,
														Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal, 		Aud_NumTransaccion
												 );


CALL EDOCTATDCRESUMMOVPRO(	Par_DiaCorte,				Par_Periodo,			Var_FecFinCorte,		Par_EmpresaID,			Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
													);

CALL EDOCTATDCTASASINTPRO(	Par_DiaCorte,				Par_Periodo,			Var_FecFinCorte,		Par_EmpresaID,			Aud_Usuario,
														Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
													);


CALL EDOCTATDCDETMOVMXGRALPRO(	Par_DiaCorte,				Par_Periodo,			Var_FecIniCorte,	Var_FecFinCorte,		Par_EmpresaID,
															Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
															Aud_NumTransaccion
														 );

CALL EDOCTATDCDETMOVEXGRALPRO(	Par_DiaCorte,				Par_Periodo,			Var_FecIniCorte,	Var_FecFinCorte,		Par_EmpresaID,
															Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
															Aud_NumTransaccion
														 );

CALL EDOCTATDCACLARACIONESPRO(	Par_DiaCorte,			Par_Periodo,			Var_FecIniCorte,	Var_FecFinCorte,		Par_EmpresaID,
															Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
															Aud_NumTransaccion
														 );



END TerminaStore$$