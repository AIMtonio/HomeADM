DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERACIONESREMESASREP`;

DELIMITER $$

CREATE PROCEDURE `OPERACIONESREMESASREP`(
    -- SP QUE GENERA REPORTE DE OPERACIONES CON REMESAS

    Par_FechaInicio			DATE,           -- Fecha de Inicio para la consulta
	Par_FechaFin			DATE,           -- Fecha Final para la consulta
    Par_EntidadTDEID        INT(11),        -- ID de la Remesa en el Catalogo (REMESACATALOGO)
    Par_TipoOperacion       INT(11),        -- ID del Tipo de Operacion (0=TODOS, 1=EFECTIVO, 2=SPEI, 3=ABONO A CTA.)
    Par_Estatus             INT(11),        -- Estatus de la Operacion (0=TODOS, 1=REGISTRADOS, 2=EN REVISION, 3=RECHAZADOS, 4=PAGADOS)

    Par_Umbral              INT(11),        -- Umbral de la operacion (Monto en Moneda Nacional)

    Aud_EmpresaID			INT(11),        -- Parametros de Auditoria
	Aud_Usuario				INT(11),        -- Parametros de Auditoria
	Aud_FechaActual			DATETIME,       -- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),    -- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),    -- Parametros de Auditoria

    Aud_Sucursal			INT(11),        -- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)      -- Parametros de Auditoria
)
TerminaStore: BEGIN
    -- Declaracion de Constantes Generales
    DECLARE	Entero_Cero 			INT(11);
    DECLARE Entero_Uno 				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Fecha_Vacia				DATE;
	DECLARE SalidaSI				CHAR(1);
	DECLARE Cadena_Vacia			VARCHAR(100);
    DECLARE SalidaNO				CHAR(1);

    -- Declaracion de Constantes para el Reporte
    DECLARE Var_RangoFechas             INT(11);
    DECLARE Var_Dias                    INT(11);
    DECLARE Var_ATM                     INT(2);              -- Variable para ATM
    DECLARE Var_POS                     INT(2);              -- Variable para POS
    DECLARE Var_NumRegistros            BIGINT(20);          -- Numero total de registros
    DECLARE Var_TimestampTranInicial    Timestamp(3);
    DECLARE Var_TimestampTranFinal      Timestamp(3);
    DECLARE Var_Channel                 VARCHAR(3);
    DECLARE Var_TokenTar                VARCHAR(500);        -- Variable para almacenar el Token de la tarjeta
    DECLARE Var_Instrumento             CHAR(1);             -- Variable que indica si es una tarjeta de credito o debito
    DECLARE Var_TarID                   CHAR(16);            -- Variable para almacenar el ID de la Tarjeta
    DECLARE Var_TarEnmascarado          CHAR(16);            -- Variable para guardar la tarjeta enmascarada
    DECLARE Var_TipCamDof				DECIMAL(14,2);
    DECLARE Var_MontoUmbralPesos		DECIMAL(18,2);

    -- Asignacion de Constantes Generales
    SET Entero_Cero 			    := 0;
    SET Entero_Uno 				    := 1;
	SET Decimal_Cero 			    := 0.0;
	SET Fecha_Vacia				    := '1900-01-01';
	SET SalidaSI				    := 'S';
	SET Cadena_Vacia 			    := '';
    SET SalidaNO 				    := 'N';

    SET Var_TipCamDof := (SELECT TipCamDof FROM MONEDAS WHERE MonedaId = 2);
    IF(Par_Umbral > Entero_Cero)THEN
		SET Var_MontoUmbralPesos := CASE Par_Umbral WHEN 1 THEN Var_TipCamDof * 1000
													WHEN 2 THEN Var_TipCamDof * 3000
													WHEN 3 THEN Var_TipCamDof * 5000 END;
    ELSE
		SET Var_MontoUmbralPesos := Entero_Cero;
    END IF;

    SELECT CAT.Nombre AS NombreEntidad, REM.RemesaFolioID AS NumIdentificacion, REM.FechaRegistro AS FechaOperacion, REM.Monto AS MontoOperacion,
        MON.DescriCorta AS Moneda, IF(REM.TipoBeneficiario = 'C',REM.ClienteID,REM.UsuarioServicioID) AS ClienteID, REM.ApellidoPaterno AS ApellidoPatBene, REM.ApellidoMaterno AS ApellidoMatBene, CONCAT(REM.PrimerNombre,' ', REM.SegundoNombre, ' ', REM.TercerNombre) AS NombreBene,
        REM.RazonSocial AS RazonSocialBene, CASE REM.TipoPersona WHEN 'F' THEN 'FISICA'
															WHEN 'A' THEN 'FISICA CON ACT. EMPRESARIAL'
                                                            WHEN 'M' THEN 'MORAL' END AS TipoPersonaBene,
                                                            CASE REM.FormaPago WHEN 'R' THEN 'EFECTIVO'
																WHEN 'S' THEN 'SPEI'
                                                                WHEN 'A' THEN 'ABONO A CUENTA' END AS TipoLiquidacion, PAG.Fecha AS FechaLiquidacion,
            PAG.Monto AS MontoLiquidacion, "PAGO REMESA" AS ConceptoPago, " " AS CausaDevolucion, MON.DescriCorta AS MonedaLiquidacion, IF(REM.FormaPago = 'S', REM.NumeroCuenta, '') AS CuentaClabe,
            '' AS ApellidoPatRemi, "" AS ApellidoMatRemi, IF(REM.TipoPersonaRemitente <> 'M',REM.NombreCompletoRemit,'') AS NombreRemi, IF(REM.TipoPersonaRemitente = 'M',REM.NombreCompletoRemit,'') AS RazonSocialRemi,
            CASE REM.TipoPersonaRemitente WHEN 'F' THEN 'FISICA'
				WHEN 'A' THEN 'FISICA CON ACT. EMPRESARIAL'
				WHEN 'M' THEN 'MORAL' END AS TipoPersonaRemi, CASE REM.Estatus WHEN 'N' THEN 'REGISTRADO'
																WHEN 'R' THEN 'REVISION OFICIAL CUMPLIMIENTO'
                                                                WHEN 'C' THEN 'RECHAZADO'
                                                                WHEN 'P' THEN 'PAGADO' END AS EstatusOperacion
	FROM REMESASWS REM
		LEFT JOIN PAGOREMESAS PAG
			ON REM.RemesaFolioID = PAG.RemesaFolio
		LEFT JOIN REMESACATALOGO CAT
			ON REM.RemesaCatalogoID = CAT.RemesaCatalogoID
		LEFT JOIN MONEDAS MON
			ON PAG.MonedaID = MON.MonedaId
	WHERE REM.FechaRegistro BETWEEN Par_FechaInicio AND Par_FechaFin
		AND IF(Par_EntidadTDEID > Entero_Cero,
			REM.RemesaCatalogoID =  Par_EntidadTDEID,
            TRUE)
		AND IF(Par_TipoOperacion > Entero_Cero,
			REM.FormaPago =  CASE Par_TipoOperacion WHEN 1 THEN 'R'
													WHEN 2 THEN 'S'
													WHEN 3 THEN 'A' END,
            TRUE)
		AND IF(Par_Estatus > Entero_Cero,
			REM.Estatus =  CASE Par_Estatus WHEN 1 THEN 'N'
											WHEN 2 THEN 'R'
											WHEN 3 THEN 'C'
											WHEN 4 THEN 'P' END,
            TRUE)
		AND IF(Par_Umbral > Entero_Cero,
				REM.Monto < Var_MontoUmbralPesos,
			TRUE);
END TerminaStore$$