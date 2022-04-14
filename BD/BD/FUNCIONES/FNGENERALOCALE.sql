
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGENERALOCALE
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGENERALOCALE`;

DELIMITER $$
CREATE FUNCTION `FNGENERALOCALE`(
	Par_LlaveParametro	VARCHAR(50)		-- Llave del archivo messages.properties
) RETURNS varchar(50) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion de Variables
	DECLARE Var_TipoInstitID			INT(11);
	DECLARE Var_SafiLocale				VARCHAR(50);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Entero_Cero					INT(11);
	DECLARE safilocale_cliente			VARCHAR(20);
	DECLARE safilocale_ctaAhorro		VARCHAR(20);
	DECLARE SCAP_Cliente				VARCHAR(20);
	DECLARE SOFIPO_Cliente				VARCHAR(20);
	DECLARE SOFOM_Cliente				VARCHAR(20);
	DECLARE SCAP_CtaAhorro				VARCHAR(20);
	DECLARE SOFIPO_CtaAhorro			VARCHAR(20);
	DECLARE SOFOM_CtaAhorro				VARCHAR(20);
	DECLARE Tipo_Socap					INT(11);
	DECLARE Tipo_Sofipo					INT(11);
	DECLARE Tipo_Sofom					INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia					:= '';
	SET Entero_Cero						:= 0;
	SET safilocale_cliente				:= 'safilocale.cliente';
	SET safilocale_ctaAhorro			:= 'safilocale.ctaAhorro';
	SET SCAP_Cliente					:= 'Socio';
	SET SOFIPO_Cliente					:= 'Cliente';
	SET SOFOM_Cliente					:= 'Cliente';
	SET SCAP_CtaAhorro					:= 'Cuenta de Ahorro';
	SET SOFIPO_CtaAhorro				:= 'Cuenta de Ahorro';
	SET SOFOM_CtaAhorro					:= 'Cuenta';
	SET Tipo_Socap						:= 6;				-- Tipo SOCAP, corresponde a la tabla TIPOSINSTITUCION
	SET Tipo_Sofipo						:= 3;				-- Tipo SOFIPO, corresponde a la tabla TIPOSINSTITUCION
	SET Tipo_Sofom						:= 4;				-- Tipo SOFOM, corresponde a la tabla TIPOSINSTITUCION

	SET Par_LlaveParametro := IFNULL(Par_LlaveParametro,Cadena_Vacia);

	-- Se obtiene el tipo de institucion financiera
	SET Var_TipoInstitID := (SELECT Ins.TipoInstitID FROM PARAMETROSSIS Par
								INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
								INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID LIMIT 1);

	SET Var_TipoInstitID := IFNULL(Var_TipoInstitID, Entero_Cero);

	CASE Par_LlaveParametro
		WHEN safilocale_cliente THEN
			SET Var_SafiLocale := (CASE Var_TipoInstitID
									WHEN Tipo_Socap THEN SCAP_Cliente
									WHEN Tipo_Sofipo THEN SOFIPO_Cliente
									WHEN Tipo_Sofom THEN SOFOM_Cliente
									ELSE SOFIPO_Cliente END);
		WHEN safilocale_ctaAhorro THEN
			SET Var_SafiLocale := (CASE Var_TipoInstitID
									WHEN Tipo_Socap THEN SCAP_CtaAhorro
									WHEN Tipo_Sofipo THEN SOFIPO_CtaAhorro
									WHEN Tipo_Sofom THEN SOFOM_CtaAhorro
									ELSE SCAP_CtaAhorro END);
		ELSE
			SET Var_SafiLocale := Par_LlaveParametro;
	END CASE;

	RETURN IFNULL(Var_SafiLocale,Par_LlaveParametro);
END$$

