-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASCONTABLESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASCONTABLESLIS`;
DELIMITER $$


CREATE PROCEDURE `CUENTASCONTABLESLIS`(
# =====================================================================================
# ------- STORED PARA LISTA DE CUENTAS CONTABLES ---------
# =====================================================================================
	Par_Descripcion 	CHAR(30),			-- Descripcion de la Cuenta
	Par_NumLis			TINYINT UNSIGNED, 	-- Numero de Lista
	Par_FechaCreacion	VARCHAR(10),		-- Fecha de consulta

	Aud_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT				-- Parametro de Auditoria
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_CtaInicialEmpl 	VARCHAR(25);
	DECLARE Var_CtaFinalEmpl	VARCHAR(25);
	DECLARE	Var_UltimoDIa		VARCHAR(10);	-- Variable para determinar el ultimo dia del mes de consulta

	--  Declaracion de constantes
	DECLARE	Lis_Principal		INT(11);
	DECLARE	Lis_Encabezado		INT(11);
	DECLARE	Lis_PrincipalAlfa	INT(11);
	DECLARE Lis_CtasContaDisper INT(11);
	DECLARE	Var_Encabezado		CHAR;

	DECLARE	Var_Detalle			CHAR;
	DECLARE	Lis_CtasDetalleID	INT(11);
	DECLARE	Lis_CtasDetalleDes	INT(11);
	DECLARE Lis_XmlCtas			INT(11);
	DECLARE Lis_Regulatorio		INT(11);

	-- Asignacion de Contantes
	SET	Lis_Principal 		:= 3;		-- Lista Principal Alfa
	SET	Lis_Encabezado		:= 2;		-- Lista Encabezado
	SET	Lis_PrincipalAlfa 	:= 1;		-- Lista Principal
	SET	Lis_CtasContaDisper	:= 5; 		-- Cuentas Contables para Pantalla Dispersion
	SET	Var_Encabezado		:= 'E';		-- Cuenta de Tipo Encabezado

	SET	Var_Detalle			:= 'D';		-- Cuenta de Tipo Detalle
	SET	Lis_CtasDetalleID 	:= 6;		-- Lista de Detalles ID
	SET	Lis_CtasDetalleDes	:= 7;		-- Lista de Detalles Descripcion
	SET Lis_XmlCtas			:= 8; 		-- Para Crear el xml usado en la Contabilidad Electronica.
	SET Lis_Regulatorio		:= 9; 		-- Cuentas Contables de la pantalla Parametros Regulatorios


	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	CuentaCompleta, CuentaMayor, Descripcion
		FROM 		CUENTASCONTABLES
		WHERE 	CuentaCompleta LIKE CONCAT(Par_Descripcion, "%")
		LIMIT 0, 10;
	END IF;

	IF(Par_NumLis = Lis_Encabezado) THEN
		SELECT	CuentaCompleta, CuentaMayor, Descripcion
		FROM 		CUENTASCONTABLES
		WHERE 	Grupo = Var_Encabezado
		AND 		(Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		OR 		CuentaCompleta LIKE CONCAT(Par_Descripcion, "%"))
		LIMIT 0, 10;
	END IF;

	IF(Par_NumLis = Lis_PrincipalAlfa) THEN
		SELECT	CuentaCompleta, CuentaMayor, Descripcion
		FROM 		CUENTASCONTABLES
		WHERE	(Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		OR 		CuentaCompleta LIKE CONCAT(Par_Descripcion, "%"))
		LIMIT 0, 10;
	END IF;

	IF(Par_NumLis = Lis_CtasContaDisper) THEN

		SELECT CtaIniGastoEmp,		CtaFinGastoEmp 		INTO
				Var_CtaInicialEmpl,	Var_CtaFinalEmpl
		FROM PARAMETROSSIS;

		SELECT	CuentaCompleta, CuentaMayor, Descripcion
		FROM 		CUENTASCONTABLES
		WHERE	(Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		OR 		CuentaCompleta LIKE CONCAT(Par_Descripcion, "%"))
		AND CuentaCompleta >= Var_CtaInicialEmpl
		AND CuentaCompleta <= Var_CtaFinalEmpl
		LIMIT 0, 15;

	END IF;

	IF(Par_NumLis = Lis_CtasDetalleID) THEN

		SELECT	CuentaCompleta, CuentaMayor, DescriCorta
		FROM 		CUENTASCONTABLES
		WHERE 	CuentaCompleta LIKE CONCAT(Par_Descripcion, "%")
			OR Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		AND Grupo = Var_Detalle
		LIMIT 0, 10;

	END IF;

	IF(Par_NumLis = Lis_CtasDetalleDes) THEN

		SELECT	CuentaCompleta, CuentaMayor, Descripcion
		FROM 		CUENTASCONTABLES
		WHERE	(Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		OR 		CuentaCompleta LIKE CONCAT(Par_Descripcion, "%"))
		AND Grupo =Var_Detalle
		LIMIT 0, 10;

	END IF;

	IF(Par_NumLis = Lis_XmlCtas) THEN

		SET Var_UltimoDia=LAST_DAY(Par_FechaCreacion);

		SELECT CodigoAgrupador,CuentaCompleta,FNLIMPIACARACTERESXML(Descripcion),Nivel,Naturaleza
			FROM CUENTASCONTABLES
			WHERE FechaCreacionCta <= Var_UltimoDia;

	END IF;

	IF(Par_NumLis = Lis_Regulatorio) THEN

		SELECT	CuentaCompleta, Descripcion
		FROM 	CUENTASCONTABLES
		WHERE 	(CuentaCompleta LIKE CONCAT(Par_Descripcion, "%") AND (CuentaCompleta LIKE '5%') )OR
				(Descripcion LIKE CONCAT("%", Par_Descripcion, "%") AND (CuentaCompleta LIKE '5%'))
		LIMIT 0, 15;

    END IF;

END TerminaStore$$
