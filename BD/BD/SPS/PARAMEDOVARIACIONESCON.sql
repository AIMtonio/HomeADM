DELIMITER ;
DROP PROCEDURE IF EXISTS PARAMEDOVARIACIONESCON;

DELIMITER $$
CREATE PROCEDURE `PARAMEDOVARIACIONESCON`(
	-- Store Procedure: Que Consulta los parametros del Reporte Financiero Estado de Variacion de Capital contable
	-- Modulo Contabilidad --> Reportes --> Reportes Contables
	Par_ParamEdoVariacionID		INT(11),			-- ID de Tabla
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ConsultaEdoFin			TEXT;			-- Salida de conceptos Financiero
	DECLARE Var_Contador				INT(11);		-- Contador de Ayuda en Ciclo
	DECLARE Var_ParamEdoVariacionID		INT(11);		-- Concepto Minimo Financiero
	DECLARE Var_ParamEdoVariacionIDMax	INT(11);		-- Concepto Maximo Financiero
	DECLARE Var_NumeroCliente			INT(11);		-- Numero de Cliente
	DECLARE Var_CapitalContribuido		INT(11);		-- Numero de Columnas de Contribuido
	DECLARE Var_CapitalGanado			INT(11);		-- Numero de Columnas de Ganado
	DECLARE Var_Nombre 					VARCHAR(50);	-- Nombre de la Columan
	DECLARE Var_Campo 					VARCHAR(500);	-- Nombre del campo

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Entero_Uno			INT(11);			-- Entero Uno
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Con_SI				CHAR(1);			-- Constante SI
	DECLARE Con_NO				CHAR(1);			-- Constante NO
	DECLARE Con_CContribuido 	CHAR(2);			-- Capital Contribuido
	DECLARE Con_CGanado 		CHAR(2);			-- Capital Ganado
	DECLARE Con_Principal		TINYINT UNSIGNED;	-- Consulta Principal
	DECLARE Con_Foranea			TINYINT UNSIGNED;	-- Consulta Foranea

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';
	SET Con_CContribuido 		:= 'CC';
	SET Con_CGanado 			:= 'CG';
	SET Con_Principal			:= 1;
	SET Entero_Uno				:= 1;

	-- Se realiza la consulta principal
	IF( Par_NumConsulta = Con_Principal ) THEN

		SELECT IFNULL(ValorParametro, Entero_Cero)
		INTO Var_NumeroCliente
		FROM PARAMGENERALES
		WHERE LlaveParametro = 'CliProcEspecifico';

		SELECT IFNULL(COUNT(ParamEdoVariacionID), Entero_Cero)
		INTO Var_CapitalContribuido
		FROM PARAMEDOVARIACIONES
		WHERE NumeroCliente = Var_NumeroCliente
		  AND MostrarColumna = Con_SI
		  AND TipoAgrupacion = Con_CContribuido;

		SELECT IFNULL(COUNT(ParamEdoVariacionID), Entero_Cero)
		INTO Var_CapitalGanado
		FROM PARAMEDOVARIACIONES
		WHERE NumeroCliente = Var_NumeroCliente
		  AND MostrarColumna = Con_SI
		  AND TipoAgrupacion = Con_CGanado;

		-- Se realizar cursor para la salida de los campo
		SET Var_ConsultaEdoFin := 'SELECT ';
		SET Var_Contador := Entero_Uno;

		SELECT IFNULL( COUNT(ParamEdoVariacionID), Entero_Cero)
		INTO   Var_ParamEdoVariacionIDMax
		FROM PARAMEDOVARIACIONES
		WHERE NumeroCliente = Var_NumeroCliente
		  AND MostrarColumna = Con_SI;

		-- Tablas de Cuentas de Detalle
		DROP TABLE IF EXISTS TMP_PARAMEDOVARIACIONES;
		CREATE TEMPORARY TABLE TMP_PARAMEDOVARIACIONES(
			RegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
			Nombre				VARCHAR(50)		NOT NULL COMMENT 'nombre del Campo',
			Campo				VARCHAR(500)	NOT NULL COMMENT 'Formula Contable',
			KEY `IDX_TMP_PARAMEDOVARIACIONES_1` (`RegistroID`));

		SET @RegistroID := Entero_Cero;

		INSERT INTO TMP_PARAMEDOVARIACIONES(RegistroID, Nombre, Campo)
		SELECT  (@RegistroID:=(@RegistroID + Entero_Uno)),	Nombre, 	CONCAT(Nombre,'|',MostrarColumna,'|',TipoAgrupacion,'|',Descripcion)
		FROM PARAMEDOVARIACIONES
		WHERE NumeroCliente = Var_NumeroCliente
		  AND MostrarColumna = Con_SI;

		SELECT IFNULL( COUNT(RegistroID), Entero_Cero)
		INTO   Var_ParamEdoVariacionIDMax
		FROM TMP_PARAMEDOVARIACIONES;

		-- Se arma el select de salida
		WHILE (Var_Contador <= Var_ParamEdoVariacionIDMax) DO

			SELECT 	RegistroID, 	Campo
			INTO  	Var_Nombre, Var_Campo
			FROM TMP_PARAMEDOVARIACIONES
			WHERE RegistroID = Var_Contador;

			SET Var_ConsultaEdoFin := CONCAT(Var_ConsultaEdoFin,' "',Var_Campo,'" AS "', Var_Nombre,'",');

			SET Var_Contador := Var_Contador + Entero_Uno;
			SET Var_Nombre := Cadena_Vacia;
			SET Var_Campo := Cadena_Vacia;

		END WHILE;

		SET Var_ConsultaEdoFin := CONCAT(Var_ConsultaEdoFin,' "',Var_CapitalContribuido,'" AS NumCapitalContribuido,',' "',Var_CapitalGanado,'" AS NumCapitalGanado');

		SET @SentenciaReg    = (Var_ConsultaEdoFin);
		PREPARE EjecutaProcReg FROM @SentenciaReg;
		EXECUTE  EjecutaProcReg;
	DEALLOCATE PREPARE EjecutaProcReg;
	END IF;

END TerminaStore$$
