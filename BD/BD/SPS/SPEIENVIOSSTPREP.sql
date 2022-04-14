DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSSTPREP`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSSTPREP`(
	-- STORED PROCEDURE ENCARGADO DE OBTENER LA INFORMACION DE LOS ENVIOS SPEI PARA LA GENERACION DE UN REPORTE
	Par_FechaInicio				DATE,				-- Fecha Inicio que se comparara con el campo FechaOperacion
	Par_FechaFin				DATE,				-- Fecha Fin que se comparara con el campo FechaOperacion
	Par_MontoTransferIni		DECIMAL(14, 2),		-- Rango inicial que se comparara con el campo MontoTransferir
	Par_MontoTransferFin		DECIMAL(14, 2),		-- Rango final que se comparara con el campo MontoTransferir
	Par_CuentaAho				BIGINT(12),			-- Cuenta de Ahorro

	Par_NumRep					TINYINT UNSIGNED,	-- Numero del Reporte a Generar

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- Parametro de Auditoria
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(20),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Fecha vacia
	DECLARE Entero_Cero			INT(11);			-- Entero vacio
	DECLARE Rep_Principal		INT(11);			-- Reporte Principal

	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia		VARCHAR(5000);		-- Sentencia de consulta a ejecutar

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			= '';				-- Cadena vacia
	SET Fecha_Vacia				= '1900-01-01';		-- Fecha vacia
	SET Entero_Cero				= 0;				-- Entero vacio
	SET Rep_Principal			= 1;				-- Reporte Principal

	-- INICIALIZACION DE PARAMETROS
	SET Par_FechaInicio			= IFNULL(Par_FechaInicio, Fecha_Vacia);
	SET Par_FechaFin			= IFNULL(Par_FechaFin, Fecha_Vacia);
	SET Par_MontoTransferIni	= IFNULL(Par_MontoTransferIni, Entero_Cero);
	SET Par_MontoTransferFin	= IFNULL(Par_MontoTransferFin, Entero_Cero);
	SET Par_CuentaAho			= IFNULL(Par_CuentaAho, Entero_Cero);

	IF(Par_NumRep = Rep_Principal) THEN
		SET Var_Sentencia	:= CONCAT(
			"SELECT
				FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.NombreOrd)) AS NombreOrd,							FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.CuentaOrd)) AS CuentaOrd,
				FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.NombreBeneficiario)) AS NombreBeneficiario,			FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.CuentaBeneficiario)) AS CuentaBeneficiario,
				FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.ConceptoPago)) AS ConceptoPago,						FNDECRYPTSAFI(TotalCargoCuenta) AS TotalCargoCuenta,
				CONVERT(CASE WHEN FNDECRYPTSAFI(SE.MontoTransferir) = '' THEN '0' ELSE FNDECRYPTSAFI(SE.MontoTransferir) END, DECIMAL(16,2)) AS MontoTransferir,
				CASE
					WHEN SE.Estatus = 'P' THEN 'PENDIENTE POR AUTORIZAR'
					WHEN SE.Estatus = 'A' THEN 'AUTORIZADA'
					WHEN SE.Estatus = 'C' THEN 'CANCELADA'
					WHEN SE.Estatus = 'T' THEN 'DETENIDA'
					WHEN SE.Estatus = 'V' THEN 'VERIFICADA'
					WHEN SE.Estatus = 'E' THEN 'ENVIADA'
					WHEN SE.Estatus = 'D' THEN 'DEVUELTA'
				END AS Estatus,
				SE.IVAPorPagar,					SE.IVAComision,							SE.CuentaAho,							SE.FechaOperacion,
				TP.Descripcion AS TipoPago,		INSREM.Descripcion AS InsRemitente,		INSREC.Descripcion AS InsReceptora,		ES.Descripcion AS EstatusEnv,
				SE.ClaveRastreo,				CD.Descripcion AS CausaDevol,			SE.FolioSpeiID,							SE.FolioSTP,
				CASE SE.OrigenOperacion
					WHEN 'V'	THEN 'VENTANILLA'
					WHEN 'M'	THEN 'BANCA MOVIL'
					WHEN 'C'	THEN 'CLIENTE SPEI'
					WHEN 'R'	THEN 'REMESA'
					WHEN 'D'	THEN 'DESEMBOLSO DE CREDITO'
					ELSE CONCAT('NO IDENTIFICADO : [', SE.OrigenOperacion, ']') END AS OrigenOperacion
			FROM SPEIENVIOS SE
				INNER JOIN TIPOSPAGOSPEI TP ON SE.TipoPagoID = TP.TipoPagoID
				INNER JOIN INSTITUCIONESSPEI INSREM ON SE.InstiRemitenteID = INSREM.InstitucionID
				INNER JOIN INSTITUCIONESSPEI INSREC ON SE.InstiReceptoraID = INSREC.InstitucionID
				INNER JOIN ESTADOSENVIOSPEI ES ON SE.EstatusEnv = ES.EstadoEnvioID
				INNER JOIN CAUSASDEVSPEI CD ON SE.CausaDevol = CD.CausaDevID
			WHERE	SE.FechaOperacion >= '", Par_FechaInicio, "' AND
						SE.FechaOperacion <= '", Par_FechaFin, "' AND
						FNDECRYPTSAFI(SE.MontoTransferir) >= ", Par_MontoTransferIni, " AND
						FNDECRYPTSAFI(SE.MontoTransferir) <= ", Par_MontoTransferFin, " AND "
		);

		IF (Par_CuentaAho = Entero_Cero) THEN
			SET Var_Sentencia	:= CONCAT(
				Var_Sentencia, "SE.CuentaAho LIKE '%%'"
			);
		ELSE
			SET Var_Sentencia	:= CONCAT(
				Var_Sentencia, "SE.CuentaAho = ", Par_CuentaAho
			);
		END IF;

		SET Var_Sentencia	:= CONCAT(
			Var_Sentencia, " ORDER BY SE.FechaRecepcion ASC;"
		);

		SET @Sentencia	:= (Var_Sentencia);

		PREPARE STSPEIENVIOSSTPREP FROM @Sentencia;
		EXECUTE STSPEIENVIOSSTPREP;
		DEALLOCATE PREPARE STSPEIENVIOSSTPREP;
	END IF;
END TerminaStore$$