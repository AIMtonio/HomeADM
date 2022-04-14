DELIMITER ; 
DROP procedure IF EXISTS `FONDEOAMORTIWSLIS`;

DELIMITER $$
CREATE  PROCEDURE `FONDEOAMORTIWSLIS`(
# ================================================================
# ------ STORE para extraer información de las tablas de amortización de los créditos con base en un fondeador -------
# ================================================================
    Par_CreditoID			TEXT,				-- Numero de Creditos, separados por coma
    Par_Etiqueta			CHAR(1),			-- Etiqueta del credito
    Par_InstitutFondeoID	INT(11),			-- Numero de la institucion de fondeo 0 en caso de recursos propios, -1 en caso de toda la cartera sin importar el fondeador.
    Par_FechaInicio			VARCHAR(10),		-- Fecha de Inicio
    Par_FechaFin			VARCHAR(10),		-- Fecha de Fin
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion

	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Sentencia 		TEXT;	-- Almacena la Sentencia de la Consulta
DECLARE	Var_FechaInicio		DATE;	-- Fecha Inicio 
DECLARE	Var_FechaFin		DATE;	-- Fecha FechaFin 
DECLARE Var_FechaSistema	DATE;			-- Almacena la Fecha del Sistema

-- Declaracion de Constantes
DECLARE Entero_Cero    		INT(11);		-- Entero Cero
DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero
DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia

DECLARE Lis_Cliente			INT(11);		-- Lista de clientes
DECLARE Lis_Creditos		INT(11);		-- Lista de Creditos
DECLARE Lis_Amortiza		INT(11);		-- Lista de Amortizaciones
DECLARE	Var_AdFiMa			CHAR(1);  -- Valor B  es ADMINISTRADOR DEL FIDEICOMISO MAESTRO	
   
DECLARE	Par_NumErr 			INT(11);				
DECLARE	Par_ErrMen 			VARCHAR(400);	

-- Asignacion de Constantes
SET Entero_Cero				:= 0; 				-- Entero Cero
SET Decimal_Cero        	:= 0.00;			-- Decimal Cero
SET Cadena_Vacia			:= '';    			-- Cadena Vacia
SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia

SET Lis_Cliente				:= 1; 				-- Lista de clientes
SET Lis_Creditos			:= 2; 				-- Lista de Creditos
SET Lis_Amortiza			:= 3; 				-- Lista de Amortizaciones

SET Par_NumErr				:= 000000;
SET Par_ErrMen				:= 'Datos Consultados Exitosamente';
SET Var_Sentencia			:= '';
SET Var_AdFiMa       		:= 'B'; -- Valor B  es ADMINISTRADOR DEL FIDEICOMISO MAESTRO
SET Var_FechaSistema		:= (SELECT FechaSistema  FROM PARAMETROSSIS WHERE EmpresaID=1);

IF(IFNULL(Par_FechaInicio, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_FechaInicio 		:= '1900-01-01';
END IF;

IF(IFNULL(Par_FechaFin, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_FechaFin 			:= '1900-01-01';
END IF;

SET Var_FechaInicio			:= STR_TO_DATE(Par_FechaInicio,'%Y-%m-%d');
SET Var_FechaFin			:= STR_TO_DATE(Par_FechaFin,'%Y-%m-%d');
SET Par_CreditoID 			:= IFNULL(Par_CreditoID, Cadena_Vacia);

-- SI SE RECIBE VALOR EN CREDITO SE IGNORAN LOS FILTROS 
IF(IFNULL(Par_CreditoID, Cadena_Vacia)) != Cadena_Vacia THEN
	SET Par_InstitutFondeoID	:= -1;
	SET Par_Etiqueta			:= Cadena_Vacia;
END IF;


DROP TABLE IF EXISTS TMPFONDEOAMORTIWSLIS_0;
CREATE TEMPORARY TABLE TMPFONDEOAMORTIWSLIS_0(
	-- Datos Cliente
	clienteID 				int(11), 		-- Id del cliente en Safi	,
	RFC 					char(13),		-- RFC del cliente		
	creditoID 				bigint(12), 	-- Número único asignado al crédito por Safi	
	numAmortizacion			int(4),			-- Número de cuota o amortización			
	fechaVencimiento		date,			-- Fecha de vencimiento o fecha de corte de la cuota NO es la fecha de exigibilidad.			
	totalPago				decimal(14,2), 	-- Total pago pactado de la cuota (Capital, Intereses, IVAs, Accesorios, Comisiones, Seguros)			
	capital					decimal(14,2),	-- Capital pactado de la cuota			
	totalInteres			decimal(14,2), 	-- Interés pactado de la cuota			
	totalIvaInteres			decimal(14,2),	--	IVA únicamente del interés			
	totalOtros				decimal(14,2),	--	Accesorios, otras comisiones e IVA de los mismos conceptos	
	tipoFondeador			char(1),		-- TIPO DE FONDEADOR 	
	EtiquetaFondeo			char(1),		-- Estatus del Fondeo, nace como No Enviado \nN = No enviado \nE = Envio de cartera etiquetado \nC = Cedido
	EtiquetaAFM				char(1)			-- Etiqueta del Administrador del Fideicomiso Maestro, N = No enviado \nE = Envio de cartera etiquetado		
);


DROP TABLE IF EXISTS TMPFONDEOAMORTIWSLIS_1;
CREATE TEMPORARY TABLE TMPFONDEOAMORTIWSLIS_1(
	-- Datos Cliente
	clienteID 				int(11), 		-- Id del cliente en Safi	,
	RFC 					char(13),		-- RFC del cliente		
	creditoID 				bigint(12), 	-- Número único asignado al crédito por Safi	
	numAmortizacion			int(4),			-- Número de cuota o amortización			
	fechaVencimiento		date,			-- Fecha de vencimiento o fecha de corte de la cuota NO es la fecha de exigibilidad.			
	totalPago				decimal(14,2), 	-- Total pago pactado de la cuota (Capital, Intereses, IVAs, Accesorios, Comisiones, Seguros)			
	capital					decimal(14,2),	-- Capital pactado de la cuota			
	totalInteres			decimal(14,2), 	-- Interés pactado de la cuota			
	totalIvaInteres			decimal(14,2),	--	IVA únicamente del interés			
	totalOtros				decimal(14,2),	--	Accesorios, otras comisiones e IVA de los mismos conceptos	
	tipoFondeador			char(1),		-- TIPO DE FONDEADOR 	
	EtiquetaFondeo			char(1),		-- Estatus del Fondeo, nace como No Enviado \nN = No enviado \nE = Envio de cartera etiquetado \nC = Cedido
	EtiquetaAFM				char(1)			-- Etiqueta del Administrador del Fideicomiso Maestro, N = No enviado \nE = Envio de cartera etiquetado		
);


SET Var_Sentencia := CONCAT(Var_Sentencia, ' INSERT INTO TMPFONDEOAMORTIWSLIS_1 ');
SET Var_Sentencia := CONCAT(Var_Sentencia, ' SELECT	CLI.ClienteID, CLI.RFCOficial, ');
SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.CreditoID,  ');
	-- Seccion de Cliente
SET Var_Sentencia := CONCAT(Var_Sentencia, ' AMO.AmortizacionID,	AMO.FechaVencim, AMO.Capital + AMO.Interes + AMO.IVAInteres, AMO.Capital, AMO.Interes, ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' AMO.IVAInteres,		0, ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' INS.TipoFondeador,		EtiquetaFondeo,			EtiquetaAFM ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM 	CREDITOS CRE ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES	CLI ON CLI.ClienteID  = CRE.ClienteID ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN PAGARECREDITO AMO ON CRE.CreditoID = AMO.CreditoID ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' LEFT OUTER JOIN INSTITUTFONDEO INS ON INS.InstitutFondID  = CRE.InstitFondeoID ' );

-- Numero de la institucion de fondeo 0 en caso de recursos propios, -1 en caso de toda la cartera sin importar el fondeador.
IF ( Par_InstitutFondeoID != -1) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND  CRE.InstitFondeoID = ', Par_InstitutFondeoID );
END IF;

IF( IFNULL(Par_CreditoID, Cadena_Vacia) != Cadena_Vacia) THEN

	SET Par_CreditoID := concat(REPLACE(Par_CreditoID,',',"','"));
	SET Var_Sentencia := CONCAT(Var_Sentencia, "WHERE   CRE.CreditoID in ('", Par_CreditoID ,"')  ");
END IF;


IF( IFNULL(Var_FechaInicio, Fecha_Vacia) != Fecha_Vacia AND  IFNULL(Var_FechaFin, Fecha_Vacia) != Fecha_Vacia) THEN
	IF( IFNULL(Par_CreditoID, Cadena_Vacia) != Cadena_Vacia ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND  CRE.FechaMinistrado BETWEEN "', Var_FechaInicio  ,'"  AND  "' ,Var_FechaFin, '" ' );

	ELSE 
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE  CRE.FechaMinistrado BETWEEN "', Var_FechaInicio  ,'"  AND  "' ,Var_FechaFin, '" ' );
	END IF; 
ELSE
	IF( IFNULL(Var_FechaInicio, Fecha_Vacia) != Fecha_Vacia) THEN
		IF( IFNULL(Par_CreditoID, Cadena_Vacia) != Cadena_Vacia ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND  CRE.FechaMinistrado >= "', Var_FechaInicio  ,'" ' );

		ELSE 
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE  CRE.FechaMinistrado >= "', Var_FechaInicio  ,'" ' );
		END IF; 
	ELSE
		IF( IFNULL(Var_FechaFin, Fecha_Vacia) != Fecha_Vacia) THEN
			IF( IFNULL(Par_CreditoID, Cadena_Vacia) != Cadena_Vacia ) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND  CRE.FechaMinistrado <= "', Var_FechaFin  ,'" ' );

			ELSE 
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE  CRE.FechaMinistrado <= "', Var_FechaFin  ,'" ' );
			END IF; 
		END IF; 
	END IF;
END IF;

SET Var_Sentencia := CONCAT(Var_Sentencia,' ; ');

SET @Sentencia	= (Var_Sentencia);
PREPARE Ejecuta FROM @Sentencia;
EXECUTE Ejecuta;
DEALLOCATE PREPARE Ejecuta;

-- SE REALIZA EL FILTRADO POR ETIQUETA 
IF( IFNULL(Par_Etiqueta, Cadena_Vacia) != Cadena_Vacia) THEN
	INSERT INTO TMPFONDEOAMORTIWSLIS_0
		SELECT * FROM TMPFONDEOAMORTIWSLIS_1 
			WHERE TipoFondeador = Var_AdFiMa
				AND EtiquetaAFM = Par_Etiqueta;

	DELETE FROM TMPFONDEOAMORTIWSLIS_1 WHERE TipoFondeador = Var_AdFiMa AND EtiquetaAFM = Par_Etiqueta;
	
	INSERT INTO TMPFONDEOAMORTIWSLIS_0
		SELECT * FROM TMPFONDEOAMORTIWSLIS_1 
			WHERE TipoFondeador != Var_AdFiMa
				AND  EtiquetaFondeo = Par_Etiqueta;
ELSE 
	INSERT INTO TMPFONDEOAMORTIWSLIS_0
		SELECT * FROM TMPFONDEOAMORTIWSLIS_1;
END IF;


IF(Par_NumLis = Lis_Cliente) THEN -- 1
	select distinct  Par_NumErr AS codigoRespuesta,	Par_ErrMen as mensajeRespuesta,	max(clienteID) as clienteID,	max(RFC) as RFC
		FROM TMPFONDEOAMORTIWSLIS_0 TMP
		GROUP BY clienteID;
END IF;

IF(Par_NumLis = Lis_Creditos) THEN -- 2 
	select 	distinct Par_NumErr AS codigoRespuesta,	Par_ErrMen as mensajeRespuesta,	max(creditoID) as creditoID, max(clienteID) as clienteID
		FROM TMPFONDEOAMORTIWSLIS_0 TMP
		GROUP BY clienteID, creditoID;
END IF;

IF(Par_NumLis = Lis_Amortiza) THEN -- 3
	SELECT  Par_NumErr AS codigoRespuesta,	Par_ErrMen AS mensajeRespuesta,	numAmortizacion,	fechaVencimiento,	totalPago,
			capital,						totalInteres,					totalIvaInteres,	totalOtros,			
			creditoID, clienteID
		FROM TMPFONDEOAMORTIWSLIS_0 TMP;

END IF;

DROP TABLE IF EXISTS TMPFONDEOAMORTIWSLIS_0;
DROP TABLE IF EXISTS TMPFONDEOAMORTIWSLIS_1;

END TerminaStore$$