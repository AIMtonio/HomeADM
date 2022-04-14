-- SP CONSTANCIARETCTERELREP

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETCTERELREP;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETCTERELREP`(
	-- SP PARA GENERAR INFORMACION DE RELACIONADOS FISCALES PARA MOSTRARLO EN LA CONSTANCIA DE RETENCION
    Par_Anio				INT(11), 			-- Anio de Consulta Constancia de Retencion
	Par_ConstanciaRetID		BIGINT(12),			-- Numero Consecutivo Constancia de Retencion
	Par_ClienteID 			INT(11),			-- Numero del Cliente
    Par_CteRelacionadoID	INT(11),			-- Numero del Cliente relacionado o 0 si el relacionado no es Cliente
	Par_Tipo				CHAR(2),			-- Tipo Relacionados Fiscales\nA = Aportante\nC = Cliente\nR = Relacionado\nAC = Aportante Cliente

    Par_RutaCBB				VARCHAR(100),		-- Ruta en donde se encuentra el Archivo CBB
    Par_NumRep         		TINYINT UNSIGNED,   -- Numero de Reporte

    Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Anio     		INT(11);		-- Anio para generar la Constancia
	DECLARE Var_RutaReporte		VARCHAR(250);	-- Ruta en donde se encuentra el prpt (ConstanciaRetencion.prpt)
    DECLARE Var_RutaExpPDF		VARCHAR(250);	-- Ruta para alojar las Constancias de Retencion en PDF
    DECLARE Var_RutaLogo		VARCHAR(100);	-- Ruta en donde se encuentra el logo de la Institucion
    DECLARE Var_RutaCedula		VARCHAR(100);	-- Ruta en donde se encuentra la Cedula Fiscal

    DECLARE Var_InstitucionID   INT(11);      	-- Almacena el Numero de la Institucion
	DECLARE Var_NombreInst		VARCHAR(100);	-- Almacena el Nombre de la Institucion
    DECLARE Var_DirFiscal		VARCHAR(250);	-- Almacena la Direccion Fiscal de la Institucion
    DECLARE Var_RFCEmisor       VARCHAR(25);	-- Almacena el RFC de la Institucion
	DECLARE Var_CliProEsp   	INT(11);		-- Almacena el Numero de Cliente para Procesos Especificos

    DECLARE Var_ConsecutivoID	INT(11);   		-- Variable consecutivo
	DECLARE Var_NumRegistros	INT(11);		-- Almacena el Numero de Registros
	DECLARE Var_Contador		INT(11);		-- Contador
    DECLARE Var_ConstanciaRetID	BIGINT(12);		-- Numero Consecutivo Constancia de Retencion
	DECLARE Var_ClienteID 		INT(11);		-- Numero de Cliente

    DECLARE Var_SucursalID   	INT(11);		-- Numero de Sucursal
	DECLARE Var_Tipo			CHAR(2);		-- Tipo Relacionados Fiscales\nA = Aportante\nC = Cliente\nR = Relacionado\nAC = Aportante Cliente
	DECLARE Var_CteRelacionadoID INT(11);		-- Numero del Cliente relacionado o 0 si el relacionado no es Cliente
    DECLARE Var_ClienteAnt		INT(11);		-- Almacena el numero de Cliente Anterior
	DECLARE Var_ContadorRel		INT(11);		-- Contador Relacionado

	DECLARE Var_InteresGravado  DECIMAL(18,2);	-- Valor del Interes Gravado
    DECLARE Var_InteresExento   DECIMAL(18,2);	-- Valor del Interes Exento
	DECLARE Var_InteresRetener	DECIMAL(12,2);	-- Valor del Interes Retenido
    DECLARE Var_InteresReal		DECIMAL(18,2);	-- Valor del Interes Real
    DECLARE Var_MontoCapital	DECIMAL(18,2);	-- Valor del Monto de Capital

	DECLARE Var_TotalGravado    DECIMAL(18,2);	-- Monto del Interes Gravado
    DECLARE Var_TotalExento     DECIMAL(18,2);	-- Monto del Interes Exento
	DECLARE Var_TotalISR        DECIMAL(12,2);	-- Monto del Interes Retenido
	DECLARE Var_TotalIntReal	DECIMAL(18,2);	-- Monto del Interes Real
    DECLARE Var_TotalMontoCap	DECIMAL(18,2);	-- Monto de Capital

    DECLARE Var_MontoIntReal	DECIMAL(18,2);	-- Monto del Interes Real
    DECLARE Var_Perdida			DECIMAL(18,2);	-- Monto de la Perdida
    DECLARE Var_MontoIntNominal	DECIMAL(18,2);	-- Monto del Interes Nominal

	-- Declaracion de constantes
	DECLARE Entero_Cero     	INT(11);
    DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE TipoAportante		CHAR(1);
    DECLARE TipoCliente			CHAR(1);

    DECLARE TipoRelacion		CHAR(1);
    DECLARE TipoAportaCte		CHAR(2);
    DECLARE DatosRelacionados	INT(11);
	DECLARE DatosIntereses		INT(11);
    DECLARE DatosCFDI			INT(11);

	-- Asignacion de constantes
	SET Entero_Cero     	:= 0; 		-- Entero Cero
	SET Decimal_Cero		:= 0.0;		-- Decimal Cero
	SET Cadena_Vacia		:= '';		-- Cadena Vacia
    SET TipoAportante		:= 'A';		-- Tipo Relacionado Fiscal: APORTANTE
    SET TipoCliente			:= 'C';		-- Tipo Relacionado Fiscal: CLIENTE

    SET TipoRelacion		:= 'R';		-- Tipo Relacionado Fiscal: RELACIONADO
    SET TipoAportaCte		:= 'AC';	-- Tipo Relacionado Fiscal: APORTANTE CLIENTE
    SET DatosRelacionados	:= 1;		-- Tipo Reporte: Datos del Relacionado
    SET DatosIntereses		:= 2;		-- Tipo Reporte: Datos Intereses
	SET DatosCFDI			:= 3;		-- Tipo Reporte: Datos CFDI

    -- 1.- Tipo Reporte: Datos del Relacionado
    IF(Par_NumRep = DatosRelacionados)THEN
		-- Cuando el Tipo Relacionado Fiscal es APORTANTE
		IF(Par_Tipo = TipoAportante)THEN
			SELECT 	ClienteID, 			PrimerNombre,		SegundoNombre,	TercerNombre,	ApellidoPaterno,
					ApellidoMaterno,	NombreCompleto,		RazonSocial,	RFC,			CURP,
					DireccionCompleta,	TipoPersona
			FROM CONSTANCIARETCTEREL
			WHERE ClienteID = Par_ClienteID
			AND Anio = Par_Anio
            AND Tipo = TipoAportante
            AND ConstanciaRetID = Par_ConstanciaRetID;
        END IF;

        -- Cuando el Tipo Relacionado Fiscal es CLIENTE
        IF(Par_Tipo = TipoCliente)THEN
			SELECT 	CteRelacionadoID, 	PrimerNombre,		SegundoNombre,	TercerNombre,	ApellidoPaterno,
					ApellidoMaterno,	NombreCompleto,		RazonSocial,	RFC,			CURP,
					DireccionCompleta,	TipoPersona
			FROM CONSTANCIARETCTEREL
			WHERE ClienteID = Par_ClienteID
            AND CteRelacionadoID = Par_CteRelacionadoID
			AND Anio = Par_Anio
            AND Tipo = TipoCliente
            AND CteRelacionadoID > Entero_Cero
            AND ConstanciaRetID = Par_ConstanciaRetID;
        END IF;

        -- Cuando el Tipo Relacionado Fiscal es RELACIONADO
		IF(Par_Tipo = TipoRelacion)THEN
			SELECT 	ClienteID, 			PrimerNombre,		SegundoNombre,	TercerNombre,	ApellidoPaterno,
					ApellidoMaterno,	NombreCompleto,		RazonSocial,	RFC,			CURP,
					DireccionCompleta,	TipoPersona
			FROM CONSTANCIARETCTEREL
			WHERE ClienteID = Par_ClienteID
            AND CteRelacionadoID = Par_CteRelacionadoID
			AND Anio = Par_Anio
            AND Tipo = TipoRelacion
            AND CteRelacionadoID = Entero_Cero
            AND ConstanciaRetID = Par_ConstanciaRetID;
        END IF;

    END IF;

	-- 2.- Tipo Reporte: Datos Intereses
    IF(Par_NumRep = DatosIntereses)THEN

        -- Cuando el Tipo Relacionado Fiscal es APORTANTE
		IF(Par_Tipo = TipoAportante)THEN

            -- Se obtiene el Monto del Capital y de los Intereses del Aportante
			SELECT	SUM(MontoCapital), SUM(MontoTotGrav),		SUM(MontoTotExent),		SUM(MontoTotRet),		SUM(MontoIntReal)
			INTO    Var_MontoCapital,	Var_InteresGravado,		Var_InteresExento,		Var_InteresRetener,		Var_InteresReal
			FROM CONSTANCIARETCTEREL
			WHERE ClienteID = Par_ClienteID
			AND Anio = Par_Anio
            AND Tipo = TipoAportante;

			SET Var_MontoCapital	:= IFNULL(Var_MontoCapital, Decimal_Cero);
			SET Var_InteresGravado	:= IFNULL(Var_InteresGravado, Decimal_Cero);
			SET Var_InteresExento	:= IFNULL(Var_InteresExento, Decimal_Cero);
			SET Var_InteresRetener	:= IFNULL(Var_InteresRetener, Decimal_Cero);
			SET Var_InteresReal		:= IFNULL(Var_InteresReal, Decimal_Cero);

            -- Se obtiene el Monto del Capital y de los Intereses cuando la persona relacionada sea Aportante Cliente
			SELECT	SUM(MontoCapital),	SUM(MontoTotGrav),		SUM(MontoTotExent),		SUM(MontoTotRet),		SUM(MontoIntReal)
			INTO    Var_TotalMontoCap,	Var_TotalGravado,		Var_TotalExento,		Var_TotalISR,			Var_TotalIntReal
			FROM CONSTANCIARETCTEREL
			WHERE CteRelacionadoID = Par_ClienteID
            AND Anio = Par_Anio
			AND Tipo = TipoAportaCte;

			SET Var_TotalMontoCap	:= IFNULL(Var_TotalMontoCap, Decimal_Cero);
			SET Var_TotalGravado	:= IFNULL(Var_TotalGravado, Decimal_Cero);
			SET Var_TotalExento		:= IFNULL(Var_TotalExento, Decimal_Cero);
			SET Var_TotalISR		:= IFNULL(Var_TotalISR, Decimal_Cero);
			SET Var_TotalIntReal	:= IFNULL(Var_TotalIntReal, Decimal_Cero);

            -- Se obtiene la suma del capital y de los intereses del Aportante
			SET Var_MontoCapital	:= Var_MontoCapital + Var_TotalMontoCap;
			SET Var_InteresGravado	:= Var_InteresGravado + Var_TotalGravado;
			SET Var_InteresExento	:= Var_InteresExento + Var_TotalExento;
			SET Var_InteresRetener	:= Var_InteresRetener + Var_TotalISR;
			SET Var_InteresReal		:= Var_InteresReal + Var_TotalIntReal;

			SET Var_MontoIntReal	:= Decimal_Cero;
            SET Var_Perdida			:= Decimal_Cero;

            IF(Var_InteresReal > Decimal_Cero)THEN
				SET Var_MontoIntReal := Var_InteresReal;
			ELSE
				SET Var_Perdida 	:= Var_InteresReal * -1;
			END IF;

            SET Var_MontoIntNominal	:= Var_InteresGravado + Var_InteresExento;
			SET Var_MontoIntNominal	:= IFNULL(Var_MontoIntNominal, Decimal_Cero);

            SELECT 	Var_MontoCapital AS Monto, Var_MontoIntNominal AS InteresGenerado, Var_InteresRetener AS InteresRetener,
					Var_MontoIntReal AS InteresReal, Var_Perdida AS Perdida;

        END IF;

		-- Cuando el Tipo Relacionado Fiscal es CLIENTE
        IF(Par_Tipo = TipoCliente)THEN

			SELECT	SUM(MontoCapital), SUM(MontoTotGrav),		SUM(MontoTotExent),		SUM(MontoTotRet),		SUM(MontoIntReal)
			INTO    Var_MontoCapital,	Var_InteresGravado,		Var_InteresExento,		Var_InteresRetener,		Var_InteresReal
			FROM CONSTANCIARETCTEREL
			WHERE Anio = Par_Anio
			AND CteRelacionadoID = Par_CteRelacionadoID
			AND Tipo = TipoCliente;

			SET Var_MontoCapital	:= IFNULL(Var_MontoCapital, Decimal_Cero);
			SET Var_InteresGravado	:= IFNULL(Var_InteresGravado, Decimal_Cero);
			SET Var_InteresExento	:= IFNULL(Var_InteresExento, Decimal_Cero);
			SET Var_InteresRetener	:= IFNULL(Var_InteresRetener, Decimal_Cero);
			SET Var_InteresReal		:= IFNULL(Var_InteresReal, Decimal_Cero);

            SET Var_MontoIntReal	:= Decimal_Cero;
            SET Var_Perdida			:= Decimal_Cero;

            IF(Var_InteresReal > Decimal_Cero)THEN
				SET Var_MontoIntReal := Var_InteresReal;
			ELSE
				SET Var_Perdida 	:= Var_InteresReal * -1;
			END IF;

            SET Var_MontoIntNominal	:= Var_InteresGravado + Var_InteresExento;
			SET Var_MontoIntNominal	:= IFNULL(Var_MontoIntNominal, Decimal_Cero);

            SELECT 	Var_MontoCapital AS Monto, Var_MontoIntNominal AS InteresGenerado, Var_InteresRetener AS InteresRetener,
					Var_MontoIntReal AS InteresReal, Var_Perdida AS Perdida;

        END IF;

		-- Cuando el Tipo Relacionado Fiscal es RELACIONADO
		IF(Par_Tipo = TipoRelacion)THEN
			SELECT	MontoCapital AS Monto, (MontoTotGrav + MontoTotExent) AS InteresGenerado,		MontoTotRet AS InteresRetener,
					IF(MontoIntReal > Decimal_Cero,MontoIntReal,Decimal_Cero) AS InteresReal,
                    IF(MontoIntReal < Decimal_Cero,MontoIntReal * -1,Decimal_Cero) AS Perdida
			FROM CONSTANCIARETCTEREL
			WHERE ClienteID = Par_ClienteID
            AND CteRelacionadoID = Par_CteRelacionadoID
			AND Anio = Par_Anio
            AND Tipo = TipoRelacion
            AND CteRelacionadoID = Entero_Cero
            AND ConstanciaRetID = Par_ConstanciaRetID;
        END IF;
    END IF;

	-- 3.- Tipo Reporte: Datos CFDI
    IF(Par_NumRep = DatosCFDI)THEN
		-- Cuando el Tipo Relacionado Fiscal es APORTANTE
		IF(Par_Tipo = TipoAportante)THEN
			SELECT 	CFDINoCertSAT,			CFDIUUID,			CFDISelloCFD,		CFDISelloSAT,	CFDICadenaOrig,
					CFDIFechaCertifica, 	CFDINoCertEmisor,	Par_RutaCBB AS RutaCBB
			FROM CONSTANCIARETCTEREL
			WHERE ClienteID = Par_ClienteID
			AND Anio = Par_Anio
            AND Tipo = TipoAportante
            AND ConstanciaRetID = Par_ConstanciaRetID;
        END IF;

         -- Cuando el Tipo Relacionado Fiscal es CLIENTE
        IF(Par_Tipo = TipoCliente)THEN
			-- Se verifica si el relacionado ya tiene un timbrado
			SELECT ConstanciaRetID INTO Var_ConstanciaRetID
			FROM CONSTANCIARETCTEREL
			WHERE Anio = Par_Anio
			AND CteRelacionadoID = Par_CteRelacionadoID
			AND Tipo = TipoCliente
			AND CadenaCFDI != Cadena_Vacia
            LIMIT 1;

			SET Var_ConstanciaRetID		:= IFNULL(Var_ConstanciaRetID, Entero_Cero);

			IF(Var_ConstanciaRetID > Entero_Cero)THEN
				SELECT 	CFDINoCertSAT,			CFDIUUID,			CFDISelloCFD,		CFDISelloSAT,	CFDICadenaOrig,
						CFDIFechaCertifica, 	CFDINoCertEmisor,	Par_RutaCBB AS RutaCBB
				FROM CONSTANCIARETCTEREL
				WHERE CteRelacionadoID = Par_CteRelacionadoID
				AND Anio = Par_Anio
				AND Tipo = TipoCliente
				AND CteRelacionadoID > Entero_Cero
				AND ConstanciaRetID = Var_ConstanciaRetID;
			ELSE
				SELECT 	CFDINoCertSAT,			CFDIUUID,			CFDISelloCFD,		CFDISelloSAT,	CFDICadenaOrig,
						CFDIFechaCertifica, 	CFDINoCertEmisor,	Par_RutaCBB AS RutaCBB
				FROM CONSTANCIARETCTEREL
				WHERE ClienteID = Par_ClienteID
				AND CteRelacionadoID = Par_CteRelacionadoID
				AND Anio = Par_Anio
				AND Tipo = TipoCliente
				AND CteRelacionadoID > Entero_Cero
				AND ConstanciaRetID = Par_ConstanciaRetID;
            END IF;
        END IF;

         -- Cuando el Tipo Relacionado Fiscal es RELACIONADO
		IF(Par_Tipo = TipoRelacion)THEN
			SELECT 	CFDINoCertSAT,			CFDIUUID,			CFDISelloCFD,		CFDISelloSAT,	CFDICadenaOrig,
					CFDIFechaCertifica, 	CFDINoCertEmisor,	Par_RutaCBB AS RutaCBB
			FROM CONSTANCIARETCTEREL
			WHERE ClienteID = Par_ClienteID
            AND CteRelacionadoID = Par_CteRelacionadoID
			AND Anio = Par_Anio
            AND Tipo = TipoRelacion
            AND CteRelacionadoID = Entero_Cero
            AND ConstanciaRetID = Par_ConstanciaRetID;
        END IF;

    END IF;


END TerminaStore$$