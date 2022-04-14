-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOSALDOSWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOSALDOSWSLIS`;
DELIMITER $$


CREATE  PROCEDURE `FONDEOSALDOSWSLIS`(
    Par_CreditoID			TEXT,				
    Par_Etiqueta			CHAR(1),			
	Par_InstitutFondeoID	INT(11),			
    Par_FechaCorte			VARCHAR(10),				

	Par_NumLis				TINYINT UNSIGNED,	

	Aud_EmpresaID       	INT(11),			
    Aud_Usuario         	INT(11),			
    Aud_FechaActual     	DATETIME,			
    Aud_DireccionIP     	VARCHAR(15),		
    Aud_ProgramaID      	VARCHAR(50),		
    Aud_Sucursal        	INT(11),			
    Aud_NumTransaccion  	BIGINT(20)  		

	)
TerminaStore: BEGIN


DECLARE Var_Sentencia 		TEXT;	
DECLARE Var_FechaSistema	DATE;			
DECLARE	Var_FechaCorte		DATE;			



DECLARE Entero_Cero    		INT(11);		
DECLARE Decimal_Cero		DECIMAL(14,2);	
DECLARE Cadena_Vacia   		CHAR(1);		
DECLARE	Fecha_Vacia			DATE;			

DECLARE Lis_Clientes		INT(11);		
DECLARE Lis_Creditos		INT(11);		
DECLARE Lis_Saldos			INT(11);		
   
DECLARE	Par_NumErr 			INT(11);				
DECLARE	Par_ErrMen 			VARCHAR(400);	
DECLARE	Var_AdFiMa			CHAR(1);  


SET Entero_Cero				:= 0; 				
SET Decimal_Cero        	:= 0.00;			
SET Cadena_Vacia			:= '';    			
SET	Fecha_Vacia				:= '1900-01-01';	

SET Lis_Clientes			:= 1; 				
SET Lis_Creditos			:= 2; 				
SET Lis_Saldos				:= 3; 				

SET Par_NumErr				:= 000000;
SET Par_ErrMen				:= 'Datos Consultados Exitosamente';
SET Var_Sentencia			:= '';
SET Var_AdFiMa       		:= 'B'; 
SET Var_FechaSistema		:= (SELECT FechaSistema  FROM PARAMETROSSIS WHERE EmpresaID=1);


IF(IFNULL(Par_FechaCorte, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_FechaCorte 		:= '1900-01-01';
END IF;
SET Var_FechaCorte			:= STR_TO_DATE(Par_FechaCorte,'%Y-%m-%d');
SET Par_CreditoID 			:= IFNULL(Par_CreditoID, Cadena_Vacia);



IF(IFNULL(Par_CreditoID, Cadena_Vacia)) != Cadena_Vacia THEN
	SET Par_InstitutFondeoID	:= -1;
	SET Par_Etiqueta			:= Cadena_Vacia;
END IF;

DROP TABLE IF EXISTS TMPFONDEOSALDOSWSLIS_0;
CREATE TEMPORARY TABLE TMPFONDEOSALDOSWSLIS_0(
	
	clienteID			int(11), 		
	RFC 				char(13),		
	creditoID 			bigint(12),		
	ProductoCreditoID	int(11),		
	tipoFondeador		char(1),		
	EtiquetaFondeo		char(1),		
	EtiquetaAFM			char(1)			
	);
DROP TABLE IF EXISTS TMPFONDEOSALDOSWSLIS_1;
CREATE TEMPORARY TABLE TMPFONDEOSALDOSWSLIS_1(
	
	clienteID			int(11), 		
	RFC 				char(13),		
	creditoID 			bigint(12),		
	ProductoCreditoID	int(11),		
	tipoFondeador		char(1),		
	EtiquetaFondeo		char(1),		
	EtiquetaAFM			char(1)			
);



SET Var_Sentencia := CONCAT(Var_Sentencia, ' INSERT INTO TMPFONDEOSALDOSWSLIS_1 ');
SET Var_Sentencia := CONCAT(Var_Sentencia, ' SELECT	CLI.ClienteID, CLI.RFCOficial, ');
SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.CreditoID,	CRE.ProductoCreditoID, ');
SET Var_Sentencia := CONCAT(Var_Sentencia, ' INS.TipoFondeador,		EtiquetaFondeo,			EtiquetaAFM ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM 	CREDITOS CRE ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES	CLI ON CLI.ClienteID  = CRE.ClienteID ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' LEFT OUTER JOIN INSTITUTFONDEO INS ON INS.InstitutFondID  = CRE.InstitFondeoID ' );


IF ( Par_InstitutFondeoID = -1) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE ' );
else 
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE  CRE.InstitFondeoID = ', Par_InstitutFondeoID , ' AND ');
END IF;

IF( IFNULL(Par_CreditoID, Cadena_Vacia) != Cadena_Vacia) THEN
	SET Par_CreditoID := concat(REPLACE(Par_CreditoID,',',"','"));
	SET Var_Sentencia := CONCAT(Var_Sentencia, "  CRE.CreditoID in ('", Par_CreditoID ,"') AND ");
END IF;

IF( IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia, '  CRE.FechaMinistrado <= "', Var_FechaCorte  ,'" ');
ELSE
	SET Var_Sentencia := CONCAT(Var_Sentencia, '  CRE.FechaMinistrado <= "', Var_FechaSistema  ,'" ');
END IF;


SET Var_Sentencia := CONCAT(Var_Sentencia,' ; ');

SET @Sentencia	= (Var_Sentencia);
PREPARE Ejecuta FROM @Sentencia;
EXECUTE Ejecuta;
DEALLOCATE PREPARE Ejecuta;


IF( IFNULL(Par_Etiqueta, Cadena_Vacia) != Cadena_Vacia) THEN
	INSERT INTO TMPFONDEOSALDOSWSLIS_0
		SELECT * FROM TMPFONDEOSALDOSWSLIS_1 
			WHERE TipoFondeador = Var_AdFiMa
				AND EtiquetaAFM = Par_Etiqueta;
	INSERT INTO TMPFONDEOSALDOSWSLIS_0
		SELECT * FROM TMPFONDEOSALDOSWSLIS_1 
			WHERE TipoFondeador != Var_AdFiMa
				AND  EtiquetaFondeo = Par_Etiqueta;
ELSE 
	INSERT INTO TMPFONDEOSALDOSWSLIS_0
		SELECT * FROM TMPFONDEOSALDOSWSLIS_1;
END IF;


IF(Par_NumLis = Lis_Clientes) THEN 
	select distinct Par_NumErr AS codigoRespuesta,	Par_ErrMen as mensajeRespuesta,	clienteID,	RFC
		FROM TMPFONDEOSALDOSWSLIS_0 TMP;
END IF;

IF(Par_NumLis = Lis_Creditos) THEN 
	select 	distinct Par_NumErr AS codigoRespuesta,	Par_ErrMen as mensajeRespuesta,				TMP.creditoID,		TMP.ProductoCreditoID,
			TMP.clienteID
	from TMPFONDEOSALDOSWSLIS_0 TMP;
END IF;

IF(Par_NumLis = Lis_Saldos) THEN 
	select 	Par_NumErr AS codigoRespuesta,	Par_ErrMen as mensajeRespuesta,			TMP.creditoID, 	TMP.clienteID,
			AmortizacionID, 	FechaVencim,	SaldoCapital, SaldoInteresOrd+ SaldoInteresAtr+ SaldoInteresVen as SaldoInteres, 
       		SaldoMoratorios, 	SaldoInteresPro, SaldoNotCargoRev+SaldoNotCargoSinIVA+SaldoNotCargoConIVA as NotaCargo,
       		SaldoCapital +SaldoInteresOrd+ SaldoInteresAtr+ SaldoInteresVen +SaldoMoratorios + SaldoInteresPro + SaldoNotCargoRev+SaldoNotCargoSinIVA+SaldoNotCargoConIVA as SaldoTotal
	from AMORTICREDITO AMO
		INNER JOIN TMPFONDEOSALDOSWSLIS_0 TMP ON TMP.creditoID = AMO.CreditoID;


END IF;

DROP TABLE TMPFONDEOSALDOSWSLIS_0;

END TerminaStore$$