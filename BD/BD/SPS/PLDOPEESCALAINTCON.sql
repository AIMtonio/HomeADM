-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEESCALAINTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEESCALAINTCON`;DELIMITER $$

CREATE PROCEDURE `PLDOPEESCALAINTCON`(

    Par_OperProcID      	BIGINT(12),
    Par_NombreProc      	VARCHAR(16),
    Par_TipoConsulta    	INT,
    Par_Salida          	CHAR(1),
    INOUT	Par_NumErr		INT,

    INOUT	Par_ErrMen		VARCHAR(400),
    INOUT	Par_ResulRev	CHAR(1),
    Par_EmpresaID       	INT,
    Aud_Usuario         	INT,
    Aud_FechaActual     	DATETIME,

    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT,
    Aud_NumTransaccion  	BIGINT
		)
TerminaStore: BEGIN


DECLARE Var_Resultado       CHAR(1);
DECLARE Var_FecDetec        DATETIME;
DECLARE Var_Producto        VARCHAR(20);
DECLARE Var_NombreProducto  VARCHAR(100);
DECLARE Var_FechaSolicitud  DATE;
DECLARE Var_Monto           DECIMAL(14,2);
DECLARE Var_UsuarioServOp	INT(11);


DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE SalidaNO			CHAR(1);
DECLARE SalidaSI			CHAR(1);
DECLARE Proc_Credito        VARCHAR(16);
DECLARE Proc_CreditoPorSol  VARCHAR(16);
DECLARE Proc_CtaAhorro      VARCHAR(16);
DECLARE Proc_InversionPRLV  VARCHAR(16);
DECLARE Proc_LineaCredito   VARCHAR(16);
DECLARE Proc_SolCredito     VARCHAR(16);
DECLARE Proc_SolFondeo      VARCHAR(16);
DECLARE Proc_Operacion      VARCHAR(16);
DECLARE TipoConPrincipal	INT;
DECLARE TipoConForanea		INT;
DECLARE TipoConResRev		INT;


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET SalidaNO            := 'N';
SET SalidaSI            := 'S';
SET Proc_Credito        := 'CREDITO';
SET Proc_CreditoPorSol  := 'CREDITOXSOLICITU';
SET Proc_CtaAhorro      := 'CTAAHO';
SET Proc_InversionPRLV  := 'INVERSION';
SET Proc_LineaCredito   := 'LINEACREDITO';
SET Proc_SolCredito     := 'SOLICITUDCREDITO';
SET Proc_SolFondeo      := 'SOLICITUDFONDEO';
SET Proc_Operacion     	:= 'OPERACION';
SET TipoConPrincipal    := 1;
SET TipoConForanea      := 2;
SET TipoConResRev       := 3;

IF(Par_TipoConsulta = TipoConResRev)THEN
    SELECT IFNULL(TipoResultEscID,Cadena_Vacia) INTO Var_Resultado
        FROM 	PLDOPEESCALAINT
        WHERE OperProcesoID	 = Par_OperProcID
          AND ProcesoEscID	 = Par_NombreProc;

    IF (Par_Salida = SalidaSI) THEN
            SELECT IFNULL(Var_Resultado,Cadena_Vacia);
    END IF;

    IF (Par_Salida = SalidaNO) THEN
            SET	Par_ResulRev	:= Var_Resultado;
    END IF;

END IF;


IF(Par_TipoConsulta = TipoConPrincipal) THEN

    IF (Par_NombreProc = Proc_Credito) THEN
        SELECT Cre.FechaActual, Cre.MontoCredito,  Cre.ProductoCreditoID, Pro.Descripcion INTO
               Var_FechaSolicitud,  Var_Monto,  Var_Producto,   Var_NombreProducto
            FROM CREDITOS Cre,
                 PRODUCTOSCREDITO Pro
            WHERE Cre.CreditoID         = Par_OperProcID
              AND Cre.ProductoCreditoID = Pro.ProducCreditoID;
    END IF;

    IF (Par_NombreProc = Proc_CreditoPorSol) THEN
        SELECT Sol.FechaRegistro, Sol.MontoAutorizado,  Sol.ProductoCreditoID, Pro.Descripcion INTO
               Var_FechaSolicitud,  Var_Monto,  Var_Producto,   Var_NombreProducto
            FROM SOLICITUDCREDITO Sol,
                 PRODUCTOSCREDITO Pro
            WHERE Sol.SolicitudCreditoID    = Par_OperProcID
              AND Sol.ProductoCreditoID     = Pro.ProducCreditoID;
    END IF;

    IF (Par_NombreProc = Proc_CtaAhorro) THEN
        SELECT Cue.FechaReg, Entero_Cero,  Cue.TipoCuentaID, Tip.Descripcion INTO
               Var_FechaSolicitud,  Var_Monto,  Var_Producto,   Var_NombreProducto
            FROM CUENTASAHO Cue,
                 TIPOSCUENTAS Tip
            WHERE Cue.CuentaAhoID   = Par_OperProcID
              AND Cue.TipoCuentaID  = Tip.TipoCuentaID;
    END IF;

    IF (Par_NombreProc = Proc_InversionPRLV) THEN
        SELECT Inv.FechaInicio, Inv.Monto,  Inv.TipoInversionID, Tip.Descripcion INTO
               Var_FechaSolicitud,  Var_Monto,  Var_Producto,   Var_NombreProducto
            FROM INVERSIONES Inv,
                 CATINVERSION Tip
            WHERE Inv.InversionID       = Par_OperProcID
              AND Inv.TipoInversionID   = Tip.TipoInversionID;
    END IF;

    IF (Par_NombreProc = Proc_LineaCredito) THEN
        SELECT Lin.FechaActual, Lin.Solicitado,  Lin.ProductoCreditoID, Pro.Descripcion INTO
               Var_FechaSolicitud,  Var_Monto,  Var_Producto,   Var_NombreProducto
            FROM LINEASCREDITO Lin,
                 PRODUCTOSCREDITO Pro
            WHERE Lin.LineaCreditoID    = Par_OperProcID
              AND Lin.ProductoCreditoID = Pro.ProducCreditoID;
    END IF;

    IF (Par_NombreProc = Proc_SolCredito) THEN
        SELECT Sol.FechaRegistro, Sol.MontoAutorizado,  Sol.ProductoCreditoID, Pro.Descripcion INTO
               Var_FechaSolicitud,  Var_Monto,  Var_Producto,   Var_NombreProducto
            FROM SOLICITUDCREDITO Sol,
                 PRODUCTOSCREDITO Pro
            WHERE Sol.SolicitudCreditoID    = Par_OperProcID
              AND Sol.ProductoCreditoID     = Pro.ProducCreditoID;

    END IF;

    IF (Par_NombreProc = Proc_SolFondeo) THEN
        SELECT Sol.FechaRegistro, MontoFondeo,  Sol.ProdInvKuboID, Pro.Descripcion INTO
               Var_FechaSolicitud,  Var_Monto,  Var_Producto,   Var_NombreProducto
            FROM FONDEOSOLICITUD Sol,
                 PRODUCTOSINVKUBO Pro
            WHERE Sol.SolFondeoID   = Par_OperProcID
              AND Sol.ProdInvKuboID = Pro.ProdInvKuboID;

    END IF;

     IF (Par_NombreProc = Proc_Operacion) THEN
        SELECT DATE(FechaOperacion) as Fecha, Monto,	FolioEscala, Opc.Descripcion as Operacion, Tmp.UsuarioServicioID
            INTO
               Var_FechaSolicitud,  Var_Monto,  Var_Producto,   Var_NombreProducto, Var_UsuarioServOp
			FROM TMPPLDVENESCALA AS Tmp
				INNER JOIN OPCIONESCAJA as Opc	ON Tmp.OpcionCajaID=Opc.OpcionCajaID
                INNER JOIN TIPORESULESCPLD as Tpl On Tmp.TipoResultEscID=Tpl.TipoResultEscID
                WHERE FolioEscala = Par_OperProcID;
    END IF;


    SELECT  OperProcesoID,  ProcesoEscID,   DATE_FORMAT(FechaDeteccion, '%Y-%m-%d') AS FechaDeteccion,     Ope.SucursalID,     Ope.ClienteID,
            MatNivelRiesgo, MatPeps,        MatCta3SinDecl,     MatDetDoctos,       MatMonto,
            MatchOtro,      MatchOtroDesc,  CveFuncionario,     TipoResultEscID,    ClaveJustEscIntID,
            SolSeguimiento, NotasRevisor,   DATE_FORMAT(FechRealizacion, '%Y-%m-%d') AS FechRealizacion,
            Cli.NombreCompleto AS NombreCompletoCliente,
            Var_UsuarioServOp as UsuarioServicioID,
            Usu.NombreCompleto AS NombreCompletoUsuario,
			CASE WHEN Var_UsuarioServOp is not null THEN Usu.RFCOficial ELSE Cli.RFCOficial END AS RFCOficial,
            Var_FechaSolicitud AS FechaSolicitud,
            FORMAT(Var_Monto,2) AS MontoOperacion,
            LPAD(Var_Producto, 4, 0) AS ProductoInstrumento,
            Var_NombreProducto AS NombreProductoInstrumento
    FROM PLDOPEESCALAINT Ope
		  LEFT JOIN CLIENTES Cli ON Ope.ClienteID=Cli.ClienteID and Var_UsuarioServOp is null
          LEFT JOIN USUARIOSERVICIO Usu ON UsuarioServicioID = Var_UsuarioServOp
		WHERE   OperProcesoID   = Par_OperProcID
		  AND   ProcesoEscID    = Par_NombreProc;


END IF;


END TerminaStore$$