-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECLASIFCARTCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECLASIFCARTCONTPRO`;
DELIMITER $$


CREATE PROCEDURE `CRECLASIFCARTCONTPRO`(
# ====================================
# -- STORE CIERRE CONTINGENTES-
# ====================================
    Par_Fecha           DATETIME,

    Par_Salida          CHAR(1),        -- indica una salida
    INOUT Par_NumErr    INT(11),        -- parametro numero de error
    INOUT Par_ErrMen    VARCHAR(400),   -- mensaje de error

    Par_EmpresaID		INT(11),
    Aud_Usuario			INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_ClasifRegID INT;
    DECLARE Var_AplSector   CHAR(1);
    DECLARE Var_AplProducto CHAR(1);
    DECLARE Var_AplActiv    CHAR(1);
    DECLARE Var_AplTipoPer  CHAR(1);
    DECLARE Var_TipConDet   INT;
    DECLARE var_RepRegID    INT;
    DECLARE Var_Control     VARCHAR(100);
    -- Declaracion de Constantes
    DECLARE Entero_Cero     INT;
    DECLARE Salida_SI       CHAR(1);
    DECLARE Constante_NO    CHAR(1);

    DECLARE CURSORCLASIFICACION CURSOR FOR
        (SELECT	ClasifRegID,    AplSector,  AplActividad,   AplProducto,    AplTipoPersona
            FROM CATCLASIFREPREG
                WHERE   Tipoconcepto    = Var_TipConDet
                  AND   ReporteID       = var_RepRegID );

    -- Asignacion de Constantes
    SET Entero_Cero     := 0;           -- Entero en Cero
    SET Var_TipConDet   := 1;           -- Tipo de Consulta: Detalle
    SET var_RepRegID    := 1;           -- Tipo de Regulatorio: R0411
    SET Salida_SI       := 'S';         -- Salida si
    SET Constante_NO    := 'N';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
            concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CRECLASIFCARTCONTPRO');
    END;

    DROP TABLE IF EXISTS TMPCRECLASIF;

    CREATE TEMPORARY TABLE TMPCRECLASIF (
        RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        CreditoID           BIGINT(12),
        ClienteID           INT(11),
        ProductoCreditoID   INT(4),
        ClasifRegID         INT(11)
        ) ENGINE=MEMORY;

    INSERT INTO TMPCRECLASIF (
        CreditoID,  ClienteID,  ProductoCreditoID,  ClasifRegID   )
    SELECT  Cre.CreditoID,  Cre.ClienteID,  Cre.ProductoCreditoID,  Cre.ClasifRegID
        FROM CREDITOSCONT Cre
        WHERE   IFNULL(Cre.ClasifRegID,Entero_Cero) = Entero_Cero
          AND   (   Cre.SaldoCapVigent + Cre.SaldoCapVencido + Cre.SaldCapVenNoExi + Cre.SaldoCapAtrasad +
                    ROUND(Cre.SaldoInterOrdin, 2) +
                    ROUND(Cre.SaldoInterAtras, 2) +
                    ROUND(Cre.SaldoInterVenc, 2) +
                    ROUND(Cre.SaldoInterProvi, 2) +
                    ROUND(Cre.SaldoIntNoConta, 2) ) > Entero_Cero;


    -- Apertura del CURSOR
    OPEN  CURSORCLASIFICACION;
    BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP
        FETCH CURSORCLASIFICACION  INTO
            Var_ClasifRegID,    Var_AplSector,  Var_AplActiv,   Var_AplProducto,	Var_AplTipoPer;

            IF(Var_AplSector = Salida_SI) THEN

                UPDATE TMPCRECLASIF temporal
                    INNER JOIN CLIENTES Cli ON temporal.ClienteID = Cli.ClienteID
                    INNER JOIN SECTORES Sec ON Cli.SectorGeneral = Sec.SectorID
                SET temporal.ClasifRegID   = Var_ClasifRegID
                    WHERE   IFNULL(temporal.ClasifRegID, Entero_Cero) = Entero_Cero
                        AND   Sec.ClasifRegID = Var_ClasifRegID
                            AND   Cli.TipoPersona =
                                    CASE WHEN Var_AplTipoPer <> Constante_NO THEN Var_AplTipoPer
                                        ELSE
                                            Cli.TipoPersona END;
            END IF;

            IF(Var_AplActiv = Salida_SI) THEN
                UPDATE TMPCRECLASIF temporal
                    INNER JOIN CLIENTES Cli ON temporal.ClienteID = Cli.ClienteID
                    INNER JOIN ACTIVIDADESBMX Act ON Cli.ActividadBancoMX   = Act.ActividadBMXID
                SET temporal.ClasifRegID = Var_ClasifRegID
                    WHERE   IFNULL(temporal.ClasifRegID, Entero_Cero) = Entero_Cero
                        AND   Act.ClasifRegID = Var_ClasifRegID
                        AND   Cli.TipoPersona = CASE WHEN Var_AplTipoPer <> Constante_NO THEN
                                                    Var_AplTipoPer
                                                ELSE
                                                    Cli.TipoPersona END;
            END IF;

            IF(Var_AplProducto = 'S') THEN
                UPDATE TMPCRECLASIF temporal
                    INNER JOIN CLIENTES Cli ON temporal.ClienteID = Cli.ClienteID
                    INNER JOIN PRODUCTOSCREDITO Pro ON temporal.ProductoCreditoID = Pro.ProducCreditoID
                SET  temporal.ClasifRegID = Var_ClasifRegID
                    WHERE   IFNULL(temporal.ClasifRegID, Entero_Cero) = Entero_Cero
                        AND   Pro.ClasifRegID = Var_ClasifRegID
                        AND   Cli.TipoPersona = CASE WHEN Var_AplTipoPer <> Constante_NO  THEN
                                                    Var_AplTipoPer
                                                ELSE
                                                    Cli.TipoPersona END;
            END IF;
        END LOOP;
    END;
    CLOSE CURSORCLASIFICACION;

    UPDATE CREDITOSCONT Cre
        INNER JOIN TMPCRECLASIF temporal ON Cre.CreditoID = temporal.CreditoID
    SET Cre.ClasifRegID = temporal.ClasifRegID
        WHERE IFNULL(temporal.ClasifRegID, Entero_Cero) <> Entero_Cero;

    DROP TABLE IF EXISTS TMPCRECLASIF;

    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := 'Informacion Procesada Exitosamente.';
    SET Var_Control := 'creditoID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$
