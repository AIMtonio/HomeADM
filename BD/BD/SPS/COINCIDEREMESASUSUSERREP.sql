DELIMITER ;
DROP PROCEDURE IF EXISTS `COINCIDEREMESASUSUSERREP`;

DELIMITER $$

CREATE PROCEDURE `COINCIDEREMESASUSUSERREP`(
    -- SP QUE GENERA REPORTES DE COINCIDENCIAS DE REGISTROS DE USUARIOS NUEVOS (REMESAS)

    Par_FechaInicio			DATE,           -- Fecha de Inicio para la consulta
	Par_FechaFin			DATE,           -- Fecha Final para la consulta
    Par_TipoCoincidencia    INT(1),         -- Tipo de Coincidencia (0=TODOS, 1=RFC, 2=CURP)

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
    DECLARE Var_TipoCURP             INT(1);     -- Tipo Coincidencia CURP
    DECLARE Var_TipoRFC              INT(1);     -- Tipo Coincidencia RFC
    DECLARE Var_RFC                  CHAR(4);    -- RFC
    DECLARE Var_CURP                 CHAR(4);    -- CURP

    -- Asignacion de Constantes Generales
    SET Entero_Cero 			    := 0;
    SET Entero_Uno 				    := 1;
	SET Decimal_Cero 			    := 0.0;
	SET Fecha_Vacia				    := '1900-01-01';
	SET SalidaSI				    := 'S';
	SET Cadena_Vacia 			    := '';
    SET SalidaNO 				    := 'N';

    -- Asignacion de constantes para el reporte
    SET Var_TipoRFC                 := 1;
    SET Var_TipoCURP                := 2;
    SET Var_RFC                     := 'RFC';
    SET Var_CURP                    := 'CURP';

    -- Mostrar todos los registros
    IF(Par_TipoCoincidencia = Entero_Cero)THEN
        SELECT UsuarioServicioID, RFC, CURP, NombreCompleto, UsuarioServCoinID, RFCCoin, CURPCoin, NombreCompletoCoin,
            PorcConcidencia
            FROM COINCIDEREMESASUSUSER
            WHERE (Fecha BETWEEN Par_FechaInicio AND Par_FechaFin);
    END IF;

    -- Tipo Coincidencia con RFC
    IF(Par_TipoCoincidencia = Var_TipoRFC)THEN
        SELECT UsuarioServicioID, RFC, CURP, NombreCompleto, UsuarioServCoinID, RFCCoin, CURPCoin, NombreCompletoCoin,
            PorcConcidencia
            FROM COINCIDEREMESASUSUSER
            WHERE TipoCoincidencia = Var_RFC AND
            (Fecha BETWEEN Par_FechaInicio AND Par_FechaFin);
    END IF;

    -- Tipo Coincidencia con CURP
    IF(Par_TipoCoincidencia = Var_TipoCURP)THEN
        SELECT UsuarioServicioID, RFC, CURP, NombreCompleto, UsuarioServCoinID, RFCCoin, CURPCoin, NombreCompletoCoin,
            PorcConcidencia
            FROM COINCIDEREMESASUSUSER
            WHERE TipoCoincidencia = Var_CURP AND
            (Fecha BETWEEN Par_FechaInicio AND Par_FechaFin);
    END IF;

END TerminaStore$$