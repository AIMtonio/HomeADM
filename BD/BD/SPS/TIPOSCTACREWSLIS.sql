-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCTACREWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCTACREWSLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSCTACREWSLIS`(




    Par_NumLis                TINYINT UNSIGNED,


    Par_EmpresaID            INT,
    Aud_Usuario                INT,
    Aud_FechaActual            DATETIME,
    Aud_DireccionIP            VARCHAR(15),
    Aud_ProgramaID            VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion        BIGINT
	)
TerminaStore:BEGIN



    DECLARE Lis_Principal        INT;

    DECLARE Estatus_Activo        CHAR(1);
    DECLARE Estatus_Vigente        CHAR(1);
    DECLARE Estatus_Vencido        CHAR(1);
    DECLARE TipoCuenta            INT(1);
    DECLARE TipoProducCredito    INT(1);
    DECLARE TipoAporSocial        INT(1);
    DECLARE AporSocialID        INT(10);
    DECLARE AporSocialDes        VARCHAR(40);

    DECLARE TipoCtaCredito        INT(1);
    DECLARE TipoCtaAhorro        INT(2);
    DECLARE Saldo_Max            DECIMAL(14,2);
    DECLARE Saldo_Min            DECIMAL(14,2);
    DECLARE Permite_Abo            CHAR(5);
    DECLARE NoPermite_Abo        CHAR(5);


    SET Lis_Principal            :=1;

    SET Estatus_Activo            :='A';
    SET Estatus_Vigente            :='V';
    SET Estatus_Vencido            :='B';
    SET TipoCuenta                := 1;
    SET TipoProducCredito        := 2;
    SET TipoAporSocial            := 3;
    SET AporSocialID            := 998;
    SET AporSocialDes            :='APORTACION SOCIAL';

    SET TipoCtaAhorro            :=1;
    SET TipoCtaCredito            :=2;
    SET Saldo_Max                :=1000000.00;
    SET Saldo_Min                :=0.00;
    SET Permite_Abo                :='true';
    SET NoPermite_Abo            :='false';



        IF(Par_NumLis = Lis_Principal) THEN
            (SELECT Tip.TipoCuentaID     AS Id_Cuenta,
                    Tip.Descripcion     AS NombreCta,
                    TipoCuenta             AS TipoCta,
                    Saldo_Max            AS SaldoMax,
                    Saldo_Min            AS SaldoMin,
                    Permite_Abo         AS PermiteAbo
                FROM
                     TIPOSCUENTAS Tip
                ORDER BY Tip.TipoCuentaID)
            UNION ALL
            (SELECT Pro.ProducCreditoID,
                    Pro.Descripcion,
                    TipoProducCredito,
                    Saldo_Max,
                    Saldo_Min,
                    Permite_Abo
                FROM
                     PRODUCTOSCREDITO Pro
                ORDER BY Pro.ProducCreditoID)
            UNION ALL
            (SELECT AporSocialID,
                    AporSocialDes,
                    TipoAporSocial,
                    Saldo_Max,
                    Saldo_Min,
                    NoPermite_Abo
            );

        END IF;

    END TerminaStore$$