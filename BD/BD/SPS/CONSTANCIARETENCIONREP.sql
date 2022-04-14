-- SP CONSTANCIARETENCIONREP
DELIMITER ;
DROP PROCEDURE IF EXISTS CONSTANCIARETENCIONREP;
DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETENCIONREP`(
-- -------------------------------------------------------------------------------------- --
-- -- SP PARA MOSTRAR INFORMACION CTE EN EL REPORTE DE CONSTANCIA DE RETENCION EN PDF  -- --
-- -------------------------------------------------------------------------------------- --
    Par_AnioProceso			INT(11), 	-- Anio de Proceso Constancia de Retencion
    Par_ClienteID          	INT(11),   	-- ID del Cliente
    Par_TipoSeccion			TINYINT(11),-- Numero de seccion para el reporte

    Par_EmpresaID       	INT(11),	-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),	-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,	-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),	-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  -- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Seccion_DatosCFDI	INT(11);			-- Seccion par los datos CFDI
    DECLARE Seccion_Intereses	INT(11);			-- Seccion de intereses
    DECLARE Seccion_DatosCte	INT(11);			-- Seccion datos cliente

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Seccion_DatosCFDI		:= 1;
    SET Seccion_Intereses		:= 2;
    SET Seccion_DatosCte		:= 3;

	-- 1.-Datos CFDI
    IF(Par_TipoSeccion = Seccion_DatosCFDI)THEN

		SELECT 	CFDINoCertSAT,		CFDIUUID,	CFDISelloCFD,	CFDISelloSAT,	CFDICadenaOrig,
				CFDIFechaCertifica, CFDINoCertEmisor,
		CONVERT(CONCAT(RutaCBB, AnioProceso, '/', LPAD(CONVERT(SucursalID,CHAR), 3, Entero_Cero), '/',
			LPAD(CONVERT(ClienteID,CHAR), 10, Entero_Cero),'-',AnioProceso,'.png'),CHAR) AS RutaCBB,
			NumeroRegla,     AnioEmision
		FROM CONSTANCIARETCTE, CONSTANCIARETPARAMS
		WHERE ClienteID = Par_ClienteID
			AND Anio = Par_AnioProceso;

	END IF;

	-- 2,. Datos intereses
	IF(Par_TipoSeccion = Seccion_Intereses)THEN

		SELECT Con.Anio,MAX(Cte.MontoCapital) AS Monto,SUM(Con.InteresGravado + Con.InteresExento) AS InteresGenerado,
			CASE WHEN SUM(Con.InteresReal) > Decimal_Cero THEN SUM(Con.InteresReal)
                ELSE Decimal_Cero END AS InteresReal,
			SUM(Con.InteresRetener) AS InteresRetener,
			CASE WHEN SUM(Con.InteresReal) < Decimal_Cero THEN SUM(Con.InteresReal)* -1
				ELSE Decimal_Cero END AS Perdida
		FROM CONSTANCIARETENCION Con,
			CONSTANCIARETCTE Cte
		WHERE Con.ClienteID = Cte.ClienteID
			AND Con.Anio = Cte.Anio
			AND Con.ClienteID = Par_ClienteID
			AND Con.Anio = Par_AnioProceso;

	END IF;

	-- 3.- Datos del cliente
    IF(Par_TipoSeccion = Seccion_DatosCte)THEN

		SELECT 	ClienteID, 		PrimerNombre,		SegundoNombre,	TercerNombre,	ApellidoPaterno,
				ApellidoMaterno,	NombreCompleto,	RazonSocial,	RFC,			CURP,
				DireccionCompleta,	TipoPersona
		FROM CONSTANCIARETCTE
		WHERE ClienteID = Par_ClienteID
			AND Anio = Par_AnioProceso;

	END IF;

END TerminaStore$$