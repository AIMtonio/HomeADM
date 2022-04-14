-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BONIFICACIONESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BONIFICACIONESREP`;

DELIMITER $$
CREATE PROCEDURE `BONIFICACIONESREP`(
	-- Store Procedure para el reporte de Bonificaciones
	-- Modulo Tesoreria
	Par_FechaInicio 		DATE,			-- Fecha de Inicio del Reporte
	Par_FechaFin			DATE,			-- Fecha de Final del Reporte
	Par_Estatus				CHAR(1),		-- Estatus de la Bonificacion

	Par_NumReporte			TINYINT UNSIGNED,-- Tipo de Reporte

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema
	DECLARE Var_Sentencia 			VARCHAR(6000);	-- Sentencia Store

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Est_Inactivo 			CHAR(1);		-- Constante Estatus Inactiva
	DECLARE Est_Vigente				CHAR(1);		-- Constante Estatus Vigente
	DECLARE Est_Pagado 				CHAR(1);		-- Constante Estatus Pagada
	DECLARE Tipo_SPEI 				CHAR(1);		-- Constante Tipo de Dispersion SPEI

	DECLARE Tipo_Cheque 			CHAR(1);		-- Constante Tipo de Dispersion Cheque
	DECLARE Tipo_OrdenPago 			CHAR(1);		-- Constante Tipo de Dispersion Orden de Pago
	DECLARE Des_Inactivo			VARCHAR(15);	-- Constante Descripcion Inactivo
	DECLARE Des_Vigente				VARCHAR(15);	-- Constante Descripcion Vigente
	DECLARE Des_Pagado 				VARCHAR(15);	-- Constante Descripcion Pagado

	DECLARE Des_SPEI 				VARCHAR(15);	-- Constante Descripcion SPEI
	DECLARE Des_Cheque 				VARCHAR(15);	-- Constante Descripcion Cheque
	DECLARE Des_OrdenPago			VARCHAR(15);	-- Constante Descripcion Orden de Pago
	DECLARE	Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero				INT(11);		-- Constante Entero Cero

	DECLARE Entero_Uno 				INT(11);		-- Constante Entero uno
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero
	DECLARE Rep_Excel 				TINYINT UNSIGNED;-- Constante Tipo de Reporte Excel
	DECLARE Rep_PDF					TINYINT UNSIGNED;-- Constante Tipo de Reporte PDF

	-- Declaracion de Consultas
	DECLARE Con_MontoAmortizado		TINYINT UNSIGNED;-- Monto que lleva amortizado la bonificacion a la fecha de consulta
	DECLARE Con_MontoPorAmortizar	TINYINT UNSIGNED;-- Monto pendiente por amortizar de la bonificacion a la fecha de consulta

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';
	SET Est_Inactivo 			:= 'I';
	SET Est_Vigente 			:= 'V';
	SET Est_Pagado 				:= 'P';
	SET Tipo_SPEI 				:= 'S';

	SET Tipo_Cheque 			:= 'C';
	SET Tipo_OrdenPago 			:= 'O';
	SET Des_Inactivo			:= 'PENDIENTE';
	SET Des_Vigente				:= 'DISPERSADA';
	SET Des_Pagado 				:= 'PAGADA';

	SET Des_SPEI 				:= 'SPEI';
	SET Des_Cheque 				:= 'CHEQUE';
	SET Des_OrdenPago			:= 'ORDEN DE PAGO';
	SET Fecha_Vacia 			:= '1900-01-01';
	SET	Entero_Cero				:= 0;

	SET	Decimal_Cero			:= 0.0;
	SET Rep_Excel 				:= 1;
	SET Rep_PDF					:= 2;

	-- Asignacion de Consulta
	SET Con_MontoAmortizado		:= 1;
	SET Con_MontoPorAmortizar	:= 2;


	SELECT IFNULL(FechaSistema, Fecha_Vacia)
	INTO Var_FechaSistema
	FROM PARAMETROSSIS LIMIT 1;

	-- Se validan parametros nulos
	SET Par_FechaInicio 	:= IFNULL(Par_FechaInicio , Var_FechaSistema);
	SET Par_FechaFin		:= IFNULL(Par_FechaFin , Var_FechaSistema);
	SET Par_Estatus 		:= IFNULL(Par_Estatus , Est_Inactivo);
	SET Par_NumReporte 		:= IFNULL(Par_NumReporte , Rep_Excel);

	-- Reporte en Formato Excel
	IF( Par_NumReporte = Rep_Excel ) THEN

		DROP TABLE IF EXISTS `TMP_BONIFICACIONES`;
		CREATE TEMPORARY TABLE `TMP_BONIFICACIONES`(
			BonificacionID		BIGINT(20) 		NOT NULL COMMENT 'ID de Bonificacion',
			ClienteID			INT(11) 		NOT NULL COMMENT 'ID de Cliente',
			NombreCliente 		VARCHAR(200)	NOT NULL COMMENT 'Nombre de Cliente',
			CuentaAhoID			BIGINT(12)		NOT NULL COMMENT 'ID de Cuenta de Ahorro',
			Monto				DECIMAL(14,2) 	NOT NULL COMMENT 'Monto de la Bonificación',

			TipoDispersion 		VARCHAR(15)		NOT NULL COMMENT 'Tipo de Dispersión \n"S" = SPEI \n"C"= Cheque \n"O"= Orden Pago',
			Estatus 			VARCHAR(15)		NOT NULL COMMENT 'Estatus de la Bonificacion \n"I".-Inactiva/Pendiente \n"A".- Activa/Dispersada \n"P".- Pagada',
			FolioDispersion 	INT(11)			NOT NULL COMMENT 'Folio de Dispersión de la Bonificación',
			Meses 				INT(11) 		NOT NULL COMMENT 'Número de meses / Amortizaciones',
			MontoAmortizado		DECIMAL(14,2) 	NOT NULL COMMENT 'Monto Amortizado de la Bonificación',

			MontoPorAmortizar	DECIMAL(14,2) 	NOT NULL COMMENT 'Monto por Amortizar de la Bonificación',
			PRIMARY KEY (`BonificacionID`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla de Reporte de Bonificaciones al Cliente';

		SET Var_Sentencia := CONCAT('
			INSERT INTO TMP_BONIFICACIONES(
				BonificacionID,		ClienteID,			NombreCliente,		CuentaAhoID,		Monto,
				TipoDispersion,		Estatus,			FolioDispersion,	Meses,				MontoAmortizado,
				MontoPorAmortizar)
			SELECT
				Bon.BonificacionID,		Bon.ClienteID,			Cli.NombreCompleto,		Bon.CuentaAhoID,		Bon.Monto, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,"
				CASE WHEN Bon.TipoDispersion = '",Tipo_SPEI,"' THEN '", Des_SPEI ,"'
					 WHEN Bon.TipoDispersion = '",Tipo_Cheque,"' THEN '", Des_Cheque ,"'
					 WHEN Bon.TipoDispersion = '",Tipo_OrdenPago,"' THEN '", Des_OrdenPago ,"'
					 ELSE '",Des_OrdenPago,"' END,
				CASE WHEN Bon.Estatus = '",Est_Inactivo,"' THEN '", Des_Inactivo ,"'
					 WHEN Bon.Estatus = '",Est_Vigente,"' THEN '", Des_Vigente ,"'
					 WHEN Bon.Estatus = '",Est_Pagado,"' THEN '", Des_Pagado ,"'
					 ELSE '",Des_Inactivo,"' END,
				Bon.FolioDispersion,	Bon.Meses,
				FNMONTOBONIFICACION(Bon.BonificacionID,'",Par_FechaFin,"',",Con_MontoAmortizado,"),
				FNMONTOBONIFICACION(Bon.BonificacionID,'",Par_FechaFin,"',",Con_MontoPorAmortizar,")
			FROM BONIFICACIONES Bon
			INNER JOIN CLIENTES Cli ON Bon.ClienteID = Cli.ClienteID
			WHERE Bon.FechaInicio BETWEEN '",Par_FechaInicio,"' AND '",Par_FechaFin,"' ");

		IF( Par_Estatus <> Cadena_Vacia ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,"   AND Bon.Estatus = '",Par_Estatus,"' ");
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			ORDER BY Bon.BonificacionID, Bon.ClienteID,Bon.CuentaAhoID;');

		SET @Sentencia := (Var_Sentencia);

		PREPARE STMBONIFICACIONESREP FROM @Sentencia;
		EXECUTE STMBONIFICACIONESREP;
		DEALLOCATE PREPARE STMBONIFICACIONESREP;

		SELECT 	BonificacionID,		ClienteID,	NombreCliente,		CuentaAhoID,	Monto,
				TipoDispersion,		Estatus,	FolioDispersion,	Meses,			MontoAmortizado,
				MontoPorAmortizar
		FROM TMP_BONIFICACIONES;

	END IF;

	DROP TABLE IF EXISTS `TMP_BONIFICACIONES`;

END TerminaStore$$