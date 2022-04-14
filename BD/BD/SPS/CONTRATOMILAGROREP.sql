DELIMITER ;
DROP PROCEDURE IF EXISTS CONTRATOMILAGROREP;

DELIMITER $$
CREATE PROCEDURE `CONTRATOMILAGROREP`(
-- SP QUE OBTIENE TODOS LOS DATOS UTILIZADOS PARA EL CONTRATO DE MICROCREDITOS 
	Par_CreditoID			BIGINT(12),	-- Numero de Credito
	Par_TipoConsulta		INT(11),	-- Indica el tipo de consulta

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
    TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CorreoFinanciera  varchar(50);
	DECLARE Var_DireccionEfinan   varchar(250);
	DECLARE Var_TelefonoFinan     varchar(45);
	DECLARE Var_MontoCredito      decimal(12,2);


	-- Declaracion de constantes
	DECLARE Con_Generales        INT(11);
	DECLARE Cadena_Vacia         VARCHAR(1);
	DECLARE Entero_Cero          INT(1);
	DECLARE Decimal_Cero         DECIMAL(14,2);



	-- Asignacion constantes 
	SET Con_Generales      :=1;
	SET Cadena_Vacia       :='';
	SET Entero_Cero		   := 0;
	SET Decimal_Cero       := 0.00;



	IF(Par_TipoConsulta = Con_Generales) THEN

	DROP TABLE IF EXISTS TMPDATOSGENERALES;
		CREATE TEMPORARY TABLE TMPDATOSGENERALES(
		  SolicitudCreditoID  bigint(20),
		  DireccionAcreditado  varchar(500),
		  DireccionObligado    varchar(500),
		  NombreObligado       varchar(200),
		  NombreAcreditado     varchar(200),
          CorreoRemFinanciera  varchar(50),
		  DireccionUEAU        varchar(250),
		  TelefonoUEAU         varchar(45),
		  FechaInicio          date,
		  FechaFin             date,
		  ValorCAT             decimal(12,2),
		  TasaFija             decimal(12,2),
		  MontoCredito         decimal(12,2),
		  NumAmortizacion      int(11),
		  DescripcionProducCre varchar(100),
		  MontoTotalCredito    decimal(12,2),
		  PlazoMesDias         varchar(50),
		  TasaLetra            varchar(200),
		  MontoLetra           varchar(200),
		  InfoComercial        CHAR(1)
		);
    INSERT INTO TMPDATOSGENERALES
	SELECT  C.SolicitudCreditoID,       D.DireccionCompleta AS DireccionAcreditado,  '' AS DireccionObligado, '' AS NombreObligado,'' AS NombreAcreditado, 
			'' AS CorreoRemFinanciera,        '' AS DireccionUEAU,        '' AS TelefonoUEAU,         C.FechaInicio,    C.FechaVencimien,             C.ValorCAT,C.TasaFija,   
			C.MontoCredito,C.NumAmortizacion, '' AS DescripcionProducCre, 0.0 AS MontoTotalCredito,   '' PlazoMesDias,'' TasaLetra,''MontoLetra,  C.AprobadoInfoComercial
	FROM CREDITOS C LEFT JOIN DIRECCLIENTE  D   ON C.ClienteID = D.ClienteID
	WHERE C.CreditoID=Par_CreditoID LIMIT 1;

	UPDATE TMPDATOSGENERALES T
	INNER JOIN OBLSOLIDARIOSPORSOLI OBL ON T.SolicitudCreditoID=OBL.SolicitudCreditoID
		LEFT OUTER JOIN OBLIGADOSSOLIDARIOS A ON OBL.OblSolidID= A.OblSolidID
		LEFT OUTER JOIN CLIENTES C ON OBL.ClienteID= C.ClienteID
        LEFT JOIN DIRECCLIENTE D ON C.ClienteID = D.ClienteID
		SET T.DireccionObligado = IFNULL(D.DireccionCompleta,Cadena_Vacia),
		    T.NombreObligado = IFNULL(C.NombreCompleto,Cadena_Vacia)
		WHERE OBL.SolicitudCreditoID=T.SolicitudCreditoID ;
    
	SELECT CorreoRemitente,DireccionUEAU,TelefonoUEAU
           INTO Var_CorreoFinanciera,Var_DireccionEfinan,Var_TelefonoFinan
		   FROM EDOCTAPARAMS;

	UPDATE TMPDATOSGENERALES T
	SET   T.CorreoRemFinanciera  =IFNULL(Var_CorreoFinanciera,Cadena_Vacia),
	      T.DireccionUEAU  =IFNULL(Var_DireccionEfinan,Cadena_Vacia),
	      T.TelefonoUEAU  = IFNULL(Var_TelefonoFinan,Cadena_Vacia);


	UPDATE TMPDATOSGENERALES T 
	INNER JOIN CREDITOS C ON T.SolicitudCreditoID=C.SolicitudCreditoID
	LEFT OUTER JOIN CLIENTES CL ON C.ClienteID= CL.ClienteID
	SET T.NombreAcreditado= CL.NombreCompleto
	WHERE C.CreditoID=Par_CreditoID;


    UPDATE TMPDATOSGENERALES T
	INNER JOIN CREDITOS C ON T.SolicitudCreditoID=C.SolicitudCreditoID
	INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID 
	SET    T.DescripcionProducCre=IFNULL(P.Descripcion,Cadena_Vacia)
	WHERE C.CreditoID=Par_CreditoID ;

	UPDATE TMPDATOSGENERALES T
	INNER JOIN CREDITOS C ON T.SolicitudCreditoID=C.SolicitudCreditoID
	INNER JOIN CREDITOSPLAZOS P ON C.PlazoID=P.PlazoID 
	SET    T.PlazoMesDias=IFNULL(P.Descripcion,Cadena_Vacia)
	WHERE C.CreditoID=Par_CreditoID ;
     
	SET Var_MontoCredito :=(SELECT (IFNULL(SUM(Capital),Decimal_Cero)+IFNULL(SUM(Interes),Decimal_Cero)+IFNULL(SUM(IVAInteres),Decimal_Cero))  
	FROM AMORTICREDITO WHERE CreditoID=Par_CreditoID);

	UPDATE TMPDATOSGENERALES T
	INNER JOIN CREDITOS C ON T.SolicitudCreditoID=C.SolicitudCreditoID
	INNER JOIN AMORTICREDITO A ON C.CreditoID=A.CreditoID 
	SET    T.MontoTotalCredito=IFNULL(Var_MontoCredito,Decimal_Cero)
	WHERE C.CreditoID=Par_CreditoID ;
    
	UPDATE TMPDATOSGENERALES T
	SET T.MontoLetra = FUNCIONNUMLETRAS(MontoTotalCredito),
	    T.TasaLetra  = FUNCIONNUMLETRAS(TasaFija);




	SELECT  SolicitudCreditoID,     DireccionAcreditado, DireccionObligado,    NombreObligado,       NombreAcreditado,
	        CorreoRemFinanciera,    DireccionUEAU,       TelefonoUEAU,         FechaInicio,          ValorCAT,            
			TasaFija,               MontoCredito,        NumAmortizacion,      DescripcionProducCre, MontoTotalCredito,   
			PlazoMesDias,           MontoLetra,          TasaLetra,            FechaFin,			 InfoComercial
		    FROM   TMPDATOSGENERALES;

	END IF;


    END TerminaStore$$