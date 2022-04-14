
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGCRECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPAGCRECON`;
DELIMITER $$


CREATE PROCEDURE `DETALLEPAGCRECON`(
/*SP para consultar el detalle de pago del credito*/
	Par_CreditoID		BIGINT(12),
	Par_FechaPago		DATE,
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE Con_RepTicket	INT;
DECLARE Con_RepTicketAgro	INT;
DECLARE Con_ProFecPag	INT;
DECLARE Decimal_Cero	DECIMAL(10,2);

DECLARE OutTotalAde VARCHAR(20);
DECLARE OutMontoPag VARCHAR(20);
DECLARE	OutProxFecPag 	VARCHAR(20);
DECLARE Var_CapVigIns	VARCHAR(20);
DECLARE Var_EstGarFira	CHAR(1);
DECLARE Var_EstCredCont	CHAR(1);

DECLARE OutTotalAdeCont VARCHAR(20);
DECLARE OutMontoPagCont VARCHAR(20);
DECLARE	OutProxFecPagCont 	VARCHAR(20);
DECLARE Var_CapVigInsCont	VARCHAR(20);

DECLARE Est_GarAplicada		CHAR(1);
DECLARE Est_Pagado			CHAR(1);
DECLARE Con_RepTicketAgroCast	INT;

-- Asignacion de constantes
SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Con_RepTicket 		:= 1;
SET	Con_RepTicketAgro 	:= 2;
SET	Con_ProFecPag 		:= 9;
SET Est_GarAplicada		:= 'P';
SET Est_Pagado			:= 'P';
SET Decimal_Cero		:= 0.0;
SET Con_RepTicketAgroCast :=  3;
IF(Par_NumCon = Con_RepTicket) THEN
    CALL CREPROXPAGCON(
    Par_CreditoID,       Con_ProFecPag,     OutTotalAde,        OutMontoPag,        OutProxFecPag,
    Var_CapVigIns,       Par_EmpresaID,     Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
    Aud_ProgramaID,      Aud_Sucursal,      Aud_NumTransaccion);

    SELECT FORMAT(
                ROUND(IFNULL(SUM(DT.MontoCapOrd +           DT.MontoCapAtr +        DT.MontoCapVen +
                                 DT.MontoIntOrd +           DT.MontoIntAtr +        DT.MontoIntVen +
                                 DT.MontoIntMora +          DT.MontoIVA +           DT.MontoComision +
                                 DT.MontoComServGar +       DT.MontoGastoAdmon +    DT.MontoSeguroCuota +
                                 DT.MontoIVASeguroCuota +   DT.MontoNotasCargo +    DT.MontoIVANotasCargo +
                                 DT.MontoAccesorios),
                                Entero_Cero),2),2) AS MontoTotal,
            FORMAT(IFNULL(SUM(DT.MontoCapOrd + DT.MontoCapAtr + DT.MontoCapVen),Entero_Cero),2) AS Capital,
            FORMAT(ROUND(IFNULL(SUM(DT.MontoIntOrd + DT.MontoIntAtr + DT.MontoIntVen),Entero_Cero),2),2) AS Interes,
            FORMAT(IFNULL(SUM(DT.MontoIntMora),Entero_Cero),2) AS MontoIntMora,
            FORMAT(IFNULL(SUM(DT.MontoIVA+DT.MontoComAnualIVA + DT.MontoIVANotasCargo),Entero_Cero),2) AS MontoIVA,
            FORMAT(IFNULL(SUM(DT.MontoComision + DT.MontoAccesorios + DT.MontoComServGar + DT.MontoNotasCargo),Entero_Cero),2) AS MontoComision,
            FORMAT(IFNULL(SUM(DT.MontoGastoAdmon),Entero_Cero),2) AS MontoGastoAdmon,
            FORMAT(ROUND(IFNULL(
                            SUM(DT.MontoCapOrd +        DT.MontoCapAtr +        DT.MontoCapVen +
                                DT.MontoIntOrd +        DT.MontoIntAtr +        DT.MontoIntVen +
                                DT.MontoIntMora +       DT.MontoIVA +           DT.MontoComision +
                                DT.MontoGastoAdmon +    DT.MontoSeguroCuota +   DT.MontoIVASeguroCuota +
                                DT.MontoComAnual+       DT.MontoComAnualIVA +   DT.MontoIVAAccesorios +
                                DT.MontoNotasCargo +    DT.MontoIVANotasCargo + DT.MontoAccesorios),
                                Entero_Cero),2),2) AS TotalPago,
            OutTotalAde,
            OutMontoPag,
            OutProxFecPag,
            CURRENT_TIME() AS Hora,
            DT.Transaccion,
            CONVERT(LPAD(CL.ClienteID,10,0),CHAR(12)) AS ClienteID,
            CL.NombreCompleto,
            IFNULL(FUNCIONTOTDEUDACRE(Par_CreditoID),Entero_Cero) AS TotalDeuda,
            DT.CreditoID,
            Var_CapVigIns AS CapitalInsoluto,
            FORMAT(IFNULL(SUM(MontoSeguroCuota),Entero_Cero),2) AS MontoSeguroCuota,
            FORMAT(IFNULL(SUM(MontoIVASeguroCuota),Entero_Cero),2) AS MontoIVASeguroCuota,
            FORMAT(IFNULL(SUM(MontoComAnual),Entero_Cero),2) AS MontoComAnual,
            FORMAT(IFNULL(SUM(MontoComAnualIVA),Entero_Cero),2) AS MontoComAnualIVA
        FROM CLIENTES CL
            LEFT OUTER JOIN  DETALLEPAGCRE DT	ON	DT.CreditoID = Par_CreditoID
            AND	DT.FechaPago = Par_FechaPago
            AND DT.ClienteID = CL.ClienteID
            AND DT.Transaccion = Aud_NumTransaccion
            WHERE DT.ClienteID = CL.ClienteID
                GROUP BY DT.CreditoID, DT.Transaccion, CL.ClienteID, CL.NombreCompleto;
END IF;

IF(Par_NumCon = Con_RepTicketAgro) THEN


	SELECT EstatusGarantiaFIRA INTO Var_EstGarFira
		FROM CREDITOS Cre
        WHERE CreditoID = Par_CreditoID;

    SET Var_EstGarFira := IFNULL(Var_EstGarFira,Cadena_Vacia);

    CALL CREPROXPAGCON(
		Par_CreditoID,       Con_ProFecPag,     OutTotalAde,        OutMontoPag,        OutProxFecPag,
		Var_CapVigIns,       Par_EmpresaID,     Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID,      Aud_Sucursal,      Aud_NumTransaccion);

	IF Var_EstGarFira = Est_GarAplicada  AND EXISTS (SELECT CreditoID FROM CREDITOSCONT WHERE CreditoID = Par_CreditoID) THEN

		SELECT Estatus INTO Var_EstCredCont
			FROM CREDITOSCONT Cont
            WHERE Cont.CreditoID = Par_CreditoID;

		IF IFNULL(Var_EstCredCont,Cadena_Vacia) <> Est_Pagado THEN
			CALL CREPROXPAGCONTCON(
			Par_CreditoID,       Con_ProFecPag,     OutTotalAdeCont,        OutMontoPagCont,        OutProxFecPagCont,
			Var_CapVigInsCont,       Par_EmpresaID,     	Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,
			Aud_ProgramaID,      Aud_Sucursal,      	Aud_NumTransaccion);

            SET OutProxFecPag := OutProxFecPagCont;
            SET OutTotalAde   := FORMAT(  CAST(REPLACE(OutTotalAde,',','') AS DECIMAL(16,2)) +
									    CAST(REPLACE(IFNULL(OutTotalAdeCont,Cadena_Vacia),',','') AS DECIMAL(16,2)) , 2);

            SET OutMontoPag   := FORMAT(  CAST(REPLACE(OutMontoPag,',','') AS DECIMAL(16,2)) +
									    CAST(REPLACE(IFNULL(OutMontoPagCont,Cadena_Vacia),',','') AS DECIMAL(16,2)) , 2);

            SET Var_CapVigIns   := FORMAT(  CAST(REPLACE(Var_CapVigIns,',','') AS DECIMAL(16,2)) +
									    CAST(REPLACE(IFNULL(Var_CapVigInsCont,Cadena_Vacia),',','') AS DECIMAL(16,2)) , 2);
		END IF;
    END IF;

    DROP TABLE IF EXISTS TMP_DETPAGCRE;

    CREATE TEMPORARY TABLE TMP_DETPAGCRE(
			MontoTotal	 	DECIMAL(16,2),
			Capital	 		DECIMAL(16,2),
			Interes	 		DECIMAL(16,2),
			MontoIntMora	DECIMAL(16,2),
			MontoIVA	 	DECIMAL(16,2),
			MontoComision	DECIMAL(16,2),
			MontoGastoAdmon	DECIMAL(16,2),
			TotalPago	 	DECIMAL(16,2),
			Transaccion	 	BIGINT,
			ClienteID	 	VARCHAR(12),
			NombreCompleto	VARCHAR(400),
			TotalDeuda	 	DECIMAL(16,2),

			MontoSeguroCuota DECIMAL(16,2),
			MontoComAnual	 DECIMAL(16,2),
			MontoComAnualIVA DECIMAL(16,2)
        );

    INSERT INTO TMP_DETPAGCRE
    SELECT
                ROUND(IFNULL(SUM(DT.MontoCapOrd +       DT.MontoCapAtr +        DT.MontoCapVen +
                                 DT.MontoIntOrd +       DT.MontoIntAtr +        DT.MontoIntVen +
                                 DT.MontoIntMora +      DT.MontoIVA +           DT.MontoComision + DT.MontoComServGar +
                                 DT.MontoGastoAdmon +   DT.MontoSeguroCuota +   DT.MontoIVASeguroCuota),
                                Entero_Cero),2) AS MontoTotal,

            IFNULL(SUM(DT.MontoCapOrd + DT.MontoCapAtr + DT.MontoCapVen),Entero_Cero) AS Capital,
            ROUND(IFNULL(SUM(DT.MontoIntOrd + DT.MontoIntAtr + DT.MontoIntVen),Entero_Cero),2) AS Interes,
            IFNULL(SUM(DT.MontoIntMora),Entero_Cero) AS MontoIntMora,
            IFNULL(SUM(DT.MontoIVA+DT.MontoIVASeguroCuota+DT.MontoComAnualIVA),Entero_Cero) AS MontoIVA,
            IFNULL(SUM(DT.MontoComision + DT.MontoComServGar),Entero_Cero) AS MontoComision,
            IFNULL(SUM(DT.MontoGastoAdmon),Entero_Cero) AS MontoGastoAdmon,
            ROUND(IFNULL(
                            SUM(DT.MontoCapOrd +        DT.MontoCapAtr +        DT.MontoCapVen +
                                DT.MontoIntOrd +        DT.MontoIntAtr +        DT.MontoIntVen +
                                DT.MontoIntMora +       DT.MontoIVA +           DT.MontoComision + DT.MontoIvaComServGar+
                                DT.MontoGastoAdmon +    DT.MontoSeguroCuota +   DT.MontoIVASeguroCuota+
                                DT.MontoComAnual+       DT.MontoComAnualIVA),
                                Entero_Cero),2) AS TotalPago,
            DT.Transaccion,
            CONVERT(LPAD(CL.ClienteID,10,0),CHAR(12)) AS ClienteID,
            CL.NombreCompleto,
            IFNULL(FUNCIONTOTDEUDACRE(Par_CreditoID),Entero_Cero) AS TotalDeuda,
            IFNULL(SUM(MontoSeguroCuota),Entero_Cero) AS MontoSeguroCuota,
            IFNULL(SUM(MontoComAnual),Entero_Cero) AS MontoComAnual,
            IFNULL(SUM(MontoComAnualIVA),Entero_Cero) AS MontoComAnualIVA
        FROM CLIENTES CL
            LEFT OUTER JOIN  DETALLEPAGCRE DT	ON	DT.CreditoID = Par_CreditoID
            AND	DT.FechaPago = Par_FechaPago
            AND DT.ClienteID = CL.ClienteID
            AND DT.Transaccion = Aud_NumTransaccion
            WHERE DT.ClienteID = CL.ClienteID
                GROUP BY DT.CreditoID, DT.Transaccion, CL.ClienteID, CL.NombreCompleto;

        INSERT INTO TMP_DETPAGCRE
        SELECT
                ROUND(IFNULL(SUM(DT.MontoCapOrd +       DT.MontoCapAtr +        DT.MontoCapVen +
                                 DT.MontoIntOrd +       DT.MontoIntAtr +        DT.MontoIntVen +
                                 DT.MontoIntMora +      DT.MontoIVA +           DT.MontoComision +
                                 DT.MontoGastoAdmon +   DT.MontoSeguroCuota +   DT.MontoIVASeguroCuota),
                                Entero_Cero),2) AS MontoTotal,

            IFNULL(SUM(DT.MontoCapOrd + DT.MontoCapAtr + DT.MontoCapVen),Entero_Cero) AS Capital,
            ROUND(IFNULL(SUM(DT.MontoIntOrd + DT.MontoIntAtr + DT.MontoIntVen),Entero_Cero),2) AS Interes,
            IFNULL(SUM(DT.MontoIntMora),Entero_Cero) AS MontoIntMora,
            IFNULL(SUM(DT.MontoIVA+DT.MontoIVASeguroCuota+DT.MontoComAnualIVA),Entero_Cero) AS MontoIVA,
            IFNULL(SUM(DT.MontoComision),Entero_Cero) AS MontoComision,
            IFNULL(SUM(DT.MontoGastoAdmon),Entero_Cero) AS MontoGastoAdmon,
            ROUND(IFNULL(
                            SUM(DT.MontoCapOrd +        DT.MontoCapAtr +        DT.MontoCapVen +
                                DT.MontoIntOrd +        DT.MontoIntAtr +        DT.MontoIntVen +
                                DT.MontoIntMora +       DT.MontoIVA +           DT.MontoComision +
                                DT.MontoGastoAdmon +    DT.MontoSeguroCuota +   DT.MontoIVASeguroCuota+
                                DT.MontoComAnual+       DT.MontoComAnualIVA),
                                Entero_Cero),2) AS TotalPago,
            DT.Transaccion,
            CONVERT(LPAD(CL.ClienteID,10,0),CHAR(12)) AS ClienteID,
            CL.NombreCompleto,
            IFNULL(FUNCIONTOTDEUDACRECONT(Par_CreditoID),Entero_Cero) AS TotalDeuda,
            IFNULL(SUM(MontoSeguroCuota),Entero_Cero) AS MontoSeguroCuota,
            IFNULL(SUM(MontoComAnual),Entero_Cero) AS MontoComAnual,
            IFNULL(SUM(MontoComAnualIVA),Entero_Cero) AS MontoComAnualIVA
        FROM CLIENTES CL
            LEFT OUTER JOIN  DETALLEPAGCRECONT DT	ON	DT.CreditoID = Par_CreditoID
            AND	DT.FechaPago = Par_FechaPago
            AND DT.ClienteID = CL.ClienteID
            AND DT.Transaccion = Aud_NumTransaccion
            WHERE DT.ClienteID = CL.ClienteID
                GROUP BY DT.CreditoID, DT.Transaccion, CL.ClienteID, CL.NombreCompleto;

		SELECT  FORMAT(SUM(MontoTotal),2) AS MontoTotal,
				FORMAT(SUM(Capital),2) AS Capital,
				FORMAT(SUM(Interes),2) AS Interes,
				FORMAT(SUM(MontoIntMora),2) AS MontoIntMora,
				FORMAT(SUM(MontoIVA),2) AS MontoIVA,
				FORMAT(SUM(MontoComision),2) AS MontoComision,
				FORMAT(SUM(MontoGastoAdmon),2) AS MontoGastoAdmon,
				FORMAT(SUM(TotalPago),2) AS TotalPago,
				OutTotalAde,
				OutMontoPag,
				OutProxFecPag,
				CURRENT_TIME() AS Hora,
				MIN(Transaccion) AS Transaccion,
				MIN(ClienteID) AS ClienteID,
				MIN(NombreCompleto) AS NombreCompleto,
				SUM(TotalDeuda) AS TotalDeuda,
				Par_CreditoID AS CreditoID,
				Var_CapVigIns AS CapitalInsoluto,
				FORMAT(SUM(MontoSeguroCuota),2) AS MontoSeguroCuota,
				FORMAT(SUM(MontoComAnual),2) AS MontoComAnual,
				FORMAT(SUM(MontoComAnualIVA),2) AS MontoComAnualIVA
                FROM TMP_DETPAGCRE;

END IF;

IF(Par_NumCon = Con_RepTicketAgroCast) THEN
	SELECT
	 ReimpresionID,		TransaccionID,		SucursalID,	   	 		UsuarioID, 	 			Fecha,
	 Efectivo, 		  	NombrePersona,      CreditoID,		 		MontoProximoPago,
     Capital, 			Interes,		 	Moratorios, 	 		Comision,				IVA,
	 EmpresaID,			Usuario,			FechaActual,	 		DireccionIP,			ProgramaID,
	 Sucursal,			NumTransaccion
	FROM REIMPRESIONTICKET
    WHERE NumTransaccion = Aud_NumTransaccion
    AND CreditoID = Par_CreditoID
    AND Fecha	= Par_FechaPago;

END IF;
END TerminaStore$$
