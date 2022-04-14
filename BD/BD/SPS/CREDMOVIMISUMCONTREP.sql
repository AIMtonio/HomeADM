-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDMOVIMISUMCONTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDMOVIMISUMCONTREP`;DELIMITER $$

CREATE PROCEDURE `CREDMOVIMISUMCONTREP`(
# ================================================================
#			REPORTE DE SUMA DE MOVIMIENTOS DE CREDITO
# ================================================================
    Par_CreditoID           BIGINT(12),		-- ID de Credito
    Par_FechaIni            DATE,			-- Parametro de fecha inicial
    Par_FechaFin            DATE,			-- Parametro de fecha final

	-- Parametros de auditoria
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN

    -- DECLARACION DE CONSTANTES --
    DECLARE Decimal_Cero        DECIMAL(12,2);
    DECLARE Entero_Cero        	INT(11);
    DECLARE Desembolso        	VARCHAR(10);
    DECLARE Pago            	VARCHAR(4);
    DECLARE Cadena_Vacia    	CHAR(1);

    -- DECLARACION DE VARIABLES --
    DECLARE Var_IVA            		DECIMAL(12,2);
    DECLARE Var_MonedaID    		INT(11);
    DECLARE Var_CobraSeguroCuota    CHAR(1);
	DECLARE Par_ErrMen				VARCHAR(400);
    DECLARE Par_NumErr    			INT(11);
	DECLARE Var_Control             VARCHAR(100);
    DECLARE Par_Salida 				CHAR(1);
    DECLARE	SalidaSI				CHAR(1);

    -- ASIGNACION DE CONSTANTES--
    SET Decimal_Cero    :=0.0;
    SET Entero_Cero     :=0;
    SET Desembolso      :='DESEMBOLSO';
    SET Pago            :='PAGO';
    SET Cadena_Vacia    :='';
	SET Par_Salida		:='N';
    SET SalidaSI		:='S';

    ManejoErrores: BEGIN
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr := 999;
                    SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                         'esto le ocasiona. Ref: SP-CREDMOVIMISUMCONTREP');
                    SET Var_Control := 'sqlexception';
                END;


    SELECT IVA,MonedaID, CobraSeguroCuota
        INTO Var_IVA,Var_MonedaID,Var_CobraSeguroCuota
			FROM CREDITOS Cre
			INNER JOIN CLIENTES Cli
			ON Cli.ClienteID = Cre.ClienteID
			INNER JOIN SUCURSALES Suc
			ON Suc.SucursalID = Cli.SucursalOrigen
			WHERE CreditoID =Par_CreditoID;


	(SELECT CreditoID, FechaInicio AS Fecha, Desembolso AS Descripcion, MontoCredito AS Monto,
		MontoCredito AS PagoCapital, Decimal_Cero AS PagoInteres, Decimal_Cero AS IVAInteres, Decimal_Cero AS PagoMora, Decimal_Cero AS IVAMora,
		Decimal_Cero AS PagoComisiones, Decimal_Cero AS IVAComisiones,
		CONVERT(LPAD(CuentaID, 11,'0'), CHAR) AS CuentaID, TIME(NOW()) AS HoraEmision,Var_MonedaID AS MonedaID,
		0 AS MontoSeguroCuota, 0 AS MontoIVASeguroCuota, Var_CobraSeguroCuota AS CobraSeguroCuota
		FROM CREDITOSCONT
		WHERE CreditoID = Par_CreditoID)
		UNION
	(SELECT CreditoID, FechaPago AS Fecha,Pago AS Descripcion, SUM(MontoTotPago) AS Monto, SUM(MontoCapOrd+MontoCapAtr+MontoCapVen) AS PagoCapital,
		SUM(MontoIntOrd+MontoIntAtr+MontoIntVen) AS PagoInteres, ROUND(CASE WHEN SUM(MontoIVA) > Entero_Cero THEN SUM(MontoIntOrd+MontoIntAtr+MontoIntVen) * Var_IVA ELSE Decimal_Cero END, 2) AS IVAInteres,
		SUM(ifnull(MontoIntMora,Entero_Cero)) AS PagoMora,ROUND(CASE WHEN SUM(MontoIVA) > Entero_Cero THEN SUM(MontoIntMora) * Var_IVA ELSE Decimal_Cero END, 2) AS IVAMora,
		SUM(MontoComision+MontoGastoAdmon) AS PagoComisiones,CASE WHEN SUM(MontoIVA) > Entero_Cero THEN SUM(MontoComision+MontoGastoAdmon) * Var_IVA ELSE Decimal_Cero END AS IVAComisiones,Cadena_Vacia,Cadena_Vacia,
		Entero_Cero, SUM(ifnull(MontoSeguroCuota,Entero_Cero)) AS MontoSeguroCuota, SUM(ifnull(MontoIVASeguroCuota,Entero_Cero)) AS MontoIVASeguroCuota,Var_CobraSeguroCuota AS CobraSeguroCuota
		FROM  DETALLEPAGCRECONT
		WHERE CreditoID = Par_CreditoID
		AND FechaPago BETWEEN Par_FechaIni AND Par_FechaFin
		GROUP BY CreditoID, FechaPago);

	END ManejoErrores;

	IF(Par_Salida =SalidaSI) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$