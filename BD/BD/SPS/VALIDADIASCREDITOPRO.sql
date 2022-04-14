-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDADIASCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDADIASCREDITOPRO`;
DELIMITER $$

CREATE PROCEDURE `VALIDADIASCREDITOPRO`(
    -- SP PARA VALIDAR DIAS TRANSCURRIDOS SIN PAGO DE CREDITOS DE NOMINA
    Par_FechaCierre         DATE,           -- Fecha del cierre
    Par_Salida              CHAR(1),        -- Indica si espera select de salida
    INOUT Par_NumErr        INT(11),        -- Numero de error
    INOUT Par_ErrMen        VARCHAR(400),   -- Mensaje de error

    Par_EmpresaID           INT(11),        -- Parametro de auditoria
    Aud_Usuario             INT(11),        -- Parametro de auditoria
    Aud_FechaActual         DATETIME,       -- Parametro de auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Parametro de auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Parametro de auditoria
    Aud_Sucursal            INT(11),        -- Parametro de auditoria
    Aud_NumTransaccion      BIGINT          -- Parametro de auditoria
    )
TerminaStore: BEGIN


DECLARE Var_InstitNominaID      VARCHAR(20);        -- Id de la institucion de nomina
DECLARE Var_Control             VARCHAR(100);       -- Variable de control
DECLARE Var_Indice              INT(11);            -- Indice del ciclo
DECLARE Var_TotRegistro         INT(11);            -- Total de registros en la tabla
DECLARE Var_CreditoID           BIGINT(12);         -- ID del credito
DECLARE Var_FechaPrimerVencim   DATE;               -- Fecha del primer vencimiento de la tabla teorica
DECLARE Var_DiasTrans           INT(11);            -- Dias transcurridos despues de la fecha de venimiento
DECLARE Var_ProdCreOri          INT(11);            -- Id del producto de credito del credito
DECLARE Var_InstNomOri          INT(11);            -- Id de la institucion de nomina del credito
DECLARE Var_ParamNumDias        INT(11);            -- numero de dias configurado en la taba parametros
DECLARE Var_SolicitudCredID     INT(11);


DECLARE Estatus_Activo  CHAR(1);            -- Estatus activo
DECLARE Cadena_Vacia    CHAR(1);            -- Cadena vacia
DECLARE Entero_Cero     INT(11);            -- Entero cero
DECLARE SalidaSI        CHAR(1);            -- Salida si
DECLARE Entero_Uno      INT(11);            -- Entero uno
DECLARE Fecha_Vacia     DATE;               -- Fecha vacia
DECLARE Estatus_Vig     CHAR(1);            -- Estatus vigente
DECLARE Estatus_Ven     CHAR(1);            -- Estatus vencido


SET Estatus_Activo  := 'A';
SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET Entero_Uno      := 1;
SET SalidaSI        := 'S';
SET Fecha_Vacia     := '1900-01-01';
SET Estatus_Vig     := 'V';
SET Estatus_Ven     := 'B';

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.
                                    Disculpe las molestias que', 'esto le ocasiona. Ref: SP-VALIDADIASCREDITOPRO');
                        SET Var_Control = 'sqlException' ;
            END;

	
    DELETE FROM TMPVALIDACREDITOS;
    INSERT INTO TMPVALIDACREDITOS (CreditoID,ProductoCreditoID,EmpresaID,Usuario,
                                FechaActual,DireccionIP,ProgramaID,Sucursal,NumTransaccion)
    SELECT c.CreditoID,     c.ProductoCreditoID,    Par_EmpresaID,  Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
    FROM CREDITOS c
        INNER JOIN PRODUCTOSCREDITO p ON c.ProductoCreditoID = p.ProducCreditoID
        INNER JOIN SOLICITUDCREDITO s ON c.CreditoID = s.CreditoID
        INNER JOIN INSTITNOMINA		i ON s.InstitucionNominaID = i.InstitNominaID
        INNER JOIN PARAMTABLAREAL	a ON i.InstitNominaID = a.EmpresaNominaID
										AND c.ProductoCreditoID = a.ProductoCreditoID
        LEFT OUTER JOIN AMORTCRENOMINAREAL r ON c.CreditoID = r.CreditoID
    WHERE p.ProductoNomina = SalidaSI
    AND c.Estatus IN(Estatus_Vig,Estatus_Ven)
    AND i.AplicaTabla = SalidaSI
    AND a.NumDias > Entero_Cero
    AND r.CreditoID IS NULL
    GROUP BY c.CreditoID,     c.ProductoCreditoID;
    
    
    INSERT INTO TMPDIASSINPAGOBAN
	SELECT tem.CreditoID,		amo.FechaVencim,		DATEDIFF(Par_FechaCierre, amo.FechaVencim) AS DiasSinPago,
            a.NumDias,			i.InstitNominaID,		tem.ProductoCreditoID,
			Par_EmpresaID,      Aud_Usuario,			Aud_FechaActual,    
            Aud_DireccionIP,	Aud_ProgramaID,     	Aud_Sucursal,       
            Aud_NumTransaccion
	FROM TMPVALIDACREDITOS tem 
			INNER JOIN AMORTICREDITO amo  ON tem.CreditoID = amo.CreditoID
			INNER JOIN SOLICITUDCREDITO s ON tem.CreditoID = s.CreditoID
			INNER JOIN INSTITNOMINA		i ON s.InstitucionNominaID = i.InstitNominaID
			INNER JOIN PARAMTABLAREAL	a ON i.InstitNominaID = a.EmpresaNominaID
											AND tem.ProductoCreditoID = a.ProductoCreditoID
	WHERE amo.AmortizacionID = Entero_Uno
	HAVING DiasSinPago >= NumDias;

	
    SET @Par_FolioNominaID  := (SELECT IFNULL(MAX(FolioNominaID),Entero_Cero)  FROM AMORTCRENOMINAREAL);

	INSERT INTO AMORTCRENOMINAREAL (
			FolioNominaID,      CreditoID,      AmortizacionID,     FechaVencimiento,   FechaExigible,
			FechaPagoIns,       Estatus,        EstatusPagoBan,     EmpresaID,          Usuario,
			FechaActual,        DireccionIP,    ProgramaID,         Sucursal,           NumTransaccion)
	SELECT @Par_FolioNominaID := @Par_FolioNominaID + Entero_Uno,
								amo.CreditoID,  amo.AmortizacionID, amo.FechaVencim,    amo.FechaExigible,
			Fecha_Vacia,      Estatus_Activo,   Estatus_Vig,        Par_EmpresaID,      Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
			FROM TMPDIASSINPAGOBAN tem,AMORTICREDITO amo
			WHERE tem.CreditoID = amo.CreditoID ;

    -- Limpia la tabla temporal
    DELETE FROM TMPVALIDACREDITOS;
    DELETE FROM TMPDIASSINPAGOBAN;

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := 'Registros agregados exitosamente';

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$