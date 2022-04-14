DELIMITER ;
DROP PROCEDURE IF EXISTS `BANPAGOCREDITOWSREP`;
DELIMITER $$
CREATE PROCEDURE `BANPAGOCREDITOWSREP`(
    Par_CreditoID           BIGINT(11),					-- ID del Credito
	Par_FechaInicio			DATE,						-- Fecha Inicio
	Par_FechaFin			DATE,						-- Fecha Fin
    Par_AmortizacionID      INT(11),					-- Numero de Amortizacion
    Par_ClienteID           INT(11),					-- ID del Cliente
	Par_NumLis  			INT(11),					-- Numero de Lista

	Aud_EmpresaID			INT(11),					-- Parametro de Auditoria
	Aud_Usuario         	INT(11),					-- Parametro de Auditoria
	Aud_FechaActual     	DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP     	VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID      	VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal        	INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion  	BIGINT(20)					-- Parametro de Auditoria
)
TerminaStore:BEGIN

    DECLARE Entero_Cero		INT(11);
    DECLARE Cadena_Vacia	CHAR;
    DECLARE Rep_PFyPM		INT(11);
    DECLARE Rep_Principal   INT(11);
    DECLARE Rep_Detalle     INT(11);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Var_SucCredito  INT(11);
    DECLARE Var_CliPagIVA   CHAR(1);
    DECLARE Var_IVASucursal DECIMAL(12,2);
    DECLARE Var_ClienteID   INT(11);                    -- ID del Cliente
    
    SET	Entero_Cero		:= 0;
    SET	Cadena_Vacia	:= '';
    SET	Rep_PFyPM		:= 1;
    SET Rep_Principal   := 2;
    SET Rep_Detalle     := 3;

    SET Fecha_Vacia       := '1900-01-01';

    SET	Par_ClienteID			:= IFNULL(Par_ClienteID, Entero_Cero);

    IF(Par_NumLis = Rep_PFyPM) THEN

        SELECT      Cli.ClienteID,           Cli.NombreCompleto,           Pag.AmortizacionID,          Pag.CreditoID,            Pag.FechaPago,
                    Pag.Transaccion,         Pag.MontoTotPago,             Pag.MontoCapOrd,             Pag.MontoCapAtr,          Pag.MontoCapVen,
                    Pag.MontoIntOrd,         Pag.MontoIntAtr,              Pag.MontoIntVen,             Pag.MontoIntMora,         Pag.MontoIVA,
                    Pag.MontoComision,       Pag.MontoGastoAdmon,          Pag.FormaPago,               Pag.MontoSeguroCuota,     Pag.MontoIVASeguroCuota,
                    Pag.MontoComAnual,       Pag.MontoComAnualIVA,         Pag.Sucursal,                Prod.ProducCreditoID,     Prod.Descripcion
            FROM DETALLEPAGCRE Pag,
                 PRODUCTOSCREDITO Prod,
                 CREDITOS Cre,
                 CLIENTES Cli
            WHERE Pag.CreditoID = Cre.CreditoID
            AND (IF (Par_FechaInicio      != Fecha_Vacia, (Pag.FechaPago >= Par_FechaInicio), true))
            AND (IF (Par_FechaFin         != Fecha_Vacia, (Pag.FechaPago <= Par_FechaFin), true))
            AND (IF (Par_CreditoID        != Entero_Cero,  (Cre.CreditoID =  Par_CreditoID), true))
            AND Cre.ProductoCreditoID     = Prod.ProducCreditoID
            AND Cre.ClienteID             = Cli.ClienteID
            AND (IF(Par_AmortizacionID != Entero_Cero, (Pag.AmortizacionID  = Par_AmortizacionID),true))
            AND (IF(Par_ClienteID != Entero_Cero, (Cre.ClienteID  = Par_ClienteID),true))
            ORDER BY Pag.FechaPago, Pag.CreditoID;

    END IF;


    IF(Par_NumLis = Rep_Principal) THEN
        SELECT     Pag.AmortizacionID,          Pag.CreditoID,            Pag.FechaPago,                Pag.MontoTotPago
            FROM DETALLEPAGCRE Pag 
            INNER JOIN CREDITOS Cre ON Pag.CreditoID = Cre.CreditoID 
            WHERE (IF (Par_FechaInicio      != Fecha_Vacia, (Pag.FechaPago >= Par_FechaInicio), true))
            AND (IF (Par_FechaFin         != Fecha_Vacia, (Pag.FechaPago <= Par_FechaFin), true))
            AND (IF (Par_CreditoID        != Entero_Cero,  (Cre.CreditoID =  Par_CreditoID), true))
            AND (IF(Par_AmortizacionID != Entero_Cero, (Pag.AmortizacionID  = Par_AmortizacionID),true))
            AND (IF(Par_ClienteID != Entero_Cero, (Cre.ClienteID  = Par_ClienteID),true))
            ORDER BY Pag.FechaPago, Pag.CreditoID;
    END IF;


    IF(Par_NumLis = Rep_Detalle) THEN
        SELECT ClienteID,SucursalID INTO Var_ClienteID, Var_SucCredito FROM CREDITOS WHERE CreditoID = Par_CreditoID;

        SELECT PagaIVA INTO Var_CliPagIVA FROM CLIENTES WHERE ClienteID = Var_ClienteID;

        SELECT IFNULL(IVA,0) INTO Var_IVASucursal FROM SUCURSALES WHERE  SucursalID = Var_SucCredito;

        SELECT      Cli.ClienteID,           Cli.NombreCompleto,           Pag.AmortizacionID,          Pag.CreditoID,            Pag.FechaPago,
                    Pag.Transaccion,         Pag.MontoTotPago,             Pag.MontoCapOrd,             Pag.MontoCapAtr,          Pag.MontoCapVen,
                    Pag.MontoIntOrd,         Pag.MontoIntAtr,              Pag.MontoIntVen,             Pag.MontoIntMora,         Pag.MontoIVA,
                    Pag.MontoComision,       Pag.MontoGastoAdmon,          Pag.FormaPago,               Pag.MontoSeguroCuota,     Pag.MontoIVASeguroCuota,
                    Pag.MontoComAnual,       Pag.MontoComAnualIVA,         Pag.Sucursal,                Prod.ProducCreditoID,     Prod.Descripcion,
                    FORMAT(ROUND((IFNULL(Pag.MontoCapOrd,0)+IFNULL(Pag.MontoCapAtr,0)+IFNULL(Pag.MontoCapVen,0)),2),2) AS TotalCapital,
                    FORMAT(ROUND(IFNULL(Pag.MontoIntOrd,0)+IFNULL(Pag.MontoIntAtr,0)+IFNULL(Pag.MontoIntVen,0),2),2) AS TotalInteres,
                    FORMAT(ROUND(IFNULL(Pag.MontoIVA,0)+IFNULL(Pag.MontoComAnualIVA,0)+IFNULL(Pag.MontoIVASeguroCuota,0),2),2) AS TotalIVAInteres
            FROM DETALLEPAGCRE Pag
			INNER JOIN CREDITOS Cre ON Pag.CreditoID = Cre.CreditoID
            INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
            INNER JOIN PRODUCTOSCREDITO Prod ON Cre.ProductoCreditoID = Prod.ProducCreditoID
            INNER JOIN SUCURSALES Suc on Suc.SucursalID = Cre.SucursalID
			WHERE (IF (Par_FechaInicio      != Fecha_Vacia, (Pag.FechaPago >= Par_FechaInicio), true))
            AND (IF (Par_FechaFin         != Fecha_Vacia, (Pag.FechaPago <= Par_FechaFin), true))
            AND (IF (Par_CreditoID        != Entero_Cero,  (Cre.CreditoID =  Par_CreditoID), true))
            AND (IF(Par_AmortizacionID != Entero_Cero, (Pag.AmortizacionID  = Par_AmortizacionID),true))
            AND (IF(Par_ClienteID != Entero_Cero, (Cre.ClienteID  = Par_ClienteID),true))
            ORDER BY Pag.FechaPago, Pag.CreditoID;
    END IF;
END TerminaStore$$
