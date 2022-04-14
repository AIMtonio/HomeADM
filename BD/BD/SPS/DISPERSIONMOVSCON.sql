-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOVSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMOVSCON`;
DELIMITER $$


CREATE PROCEDURE `DISPERSIONMOVSCON`(
# =====================================================================================
# ------- SP PARA CONSULTAR LOS MOVIMIENTOS DE DISPERSION DE ORDENES DE PAGO ---------
# =====================================================================================
    Par_SolcitudID	 		INT(11),			-- SolicitudID
    Par_Refencia	 		VARCHAR(50),		-- Referencia
	Par_NumCon				TINYINT UNSIGNED,	-- Numero  de Consulta

    Aud_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
	DECLARE Con_OrdenPago		INT(11);			-- Orden de pago
	DECLARE Lis_CanOrderPagSol	INT(11);			-- Lista para cancelar la dispersion por solicitud de credito
	DECLARE Lis_CanOrderPagRef	INT(11);			-- Lista para cancelar la dispersion por referencia
    
    -- ASIGNACIŃ DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';
	SET Con_OrdenPago          	:= 5;
	SET Lis_CanOrderPagSol     	:= 1;
	SET Lis_CanOrderPagRef     	:= 2;


	IF(Par_NumCon = Lis_CanOrderPagSol) THEN
		SELECT  CRE.SolicitudCreditoID,		CLI.NombreCompleto,		CRE.CreditoID,	 		DIS.CuentaDestino, 			DIS.Monto,	
				DIS.DispersionID,			DIS.ClaveDispMov,		CASE IFNULL(DIS.Estatus,'') WHEN 'A' THEN 'AUTORIZADA' ELSE '' END AS Estatus
			FROM DISPERSIONMOV DIS
            LEFT OUTER JOIN CREDITOS CRE ON CRE.CreditoID=DIS.CreditoID
            LEFT OUTER JOIN CLIENTES CLI ON CLI.ClienteID=CRE.ClienteID
            WHERE DIS.FormaPago=Con_OrdenPago
            AND DIS.Estatus='A'
            AND CRE.SolicitudCreditoID=Par_SolcitudID;
    END IF;
    
    IF(Par_NumCon = Lis_CanOrderPagRef) THEN
		SELECT  CRE.SolicitudCreditoID,		CLI.NombreCompleto,		CRE.CreditoID,	 		DIS.CuentaDestino, 			DIS.Monto,	
				DIS.DispersionID,			DIS.ClaveDispMov,		CASE IFNULL(DIS.Estatus,'') WHEN 'A' THEN 'AUTORIZADA' ELSE '' END AS Estatus
			FROM DISPERSIONMOV DIS
            LEFT OUTER JOIN CREDITOS CRE ON CRE.CreditoID=DIS.CreditoID
            LEFT OUTER JOIN CLIENTES CLI ON CLI.ClienteID=CRE.ClienteID
            WHERE DIS.FormaPago=Con_OrdenPago
            AND DIS.Estatus='A'
            AND DIS.CuentaDestino=Par_Refencia;
    END IF;


END TerminaStore$$