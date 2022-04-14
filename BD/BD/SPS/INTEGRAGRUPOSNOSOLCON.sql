-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSNOSOLCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSNOSOLCON`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPOSNOSOLCON`(
    Par_GrupoID         BIGINT(12),
    Par_ClienteID       INT,
    Par_TipoLista       INT,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)


        )
TerminaStore: BEGIN

    DECLARE Var_Control     VARCHAR (200);
    DECLARE Var_CreditoID   BIGINT(12);
    DECLARE Var_ExigDia     DECIMAL(12,2);
    DECLARE Var_TotalDia    DECIMAL(12,2);
    DECLARE Var_SaldoAho    DECIMAL(12,2);
    DECLARE Var_TotalSaldo  DECIMAL(12,2);


    DECLARE Entero_Cero     INT;
    DECLARE SalidaSI        CHAR(1);
    DECLARE EstatusVig      CHAR(1);
    DECLARE EstatusVen      CHAR(1);
    DECLARE EstatusAct      CHAR(1);
    DECLARE EstatusBlo      CHAR(1);
    DECLARE Tipo_LisSaldos  INT;


    DECLARE CREDITOSCLIENTE CURSOR FOR
            SELECT CreditoID
                FROM CREDITOS
                    WHERE ClienteID=Par_ClienteID
                        AND  Estatus IN(EstatusVig,EstatusVen);


    DECLARE SALDOCLIENTE CURSOR FOR
            SELECT SaldoDispon
                FROM CUENTASAHO
                    WHERE ClienteID=Par_ClienteID
                        AND Estatus IN(EstatusAct,EstatusBlo);


    SET Entero_Cero     := 0;
    SET SalidaSI        :='S';
    SET EstatusVig      :='V';
    SET EstatusVen      :='B';
    SET EstatusAct      :='A';
    SET EstatusBlo      :='B';
    SET Var_ExigDia     :=0.0;
    SET Var_TotalDia    :=0.0;
    SET Var_SaldoAho    :=0.0;
    SET Var_TotalSaldo  :=0.0;
    SET Tipo_LisSaldos  :=2;


    IF(Tipo_LisSaldos = Par_TipoLista) THEN

    OPEN  CREDITOSCLIENTE;
            BEGIN
                    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                    CICLOCREDITOSCLIEN: LOOP
                    FETCH CREDITOSCLIENTE  INTO Var_CreditoID;

                     SET   Var_TotalDia := Var_TotalDia + IFNULL((FUNCIONTOTDEUDACRE(Var_CreditoID)),Entero_Cero);
                     SET   Var_ExigDia  := Var_ExigDia + IFNULL((FUNCIONEXIGIBLE(Var_CreditoID)),Entero_Cero);
                END LOOP CICLOCREDITOSCLIEN;
            END;

    CLOSE CREDITOSCLIENTE;



    OPEN  SALDOCLIENTE;
            BEGIN
                    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                    CICLOSALDOCLIEN: LOOP
                       FETCH SALDOCLIENTE  INTO Var_SaldoAho;

                        SET Var_TotalSaldo := Var_TotalSaldo +IFNULL(Var_SaldoAho,Entero_Cero);
                END LOOP CICLOSALDOCLIEN;
            END;
    CLOSE SALDOCLIENTE;

    SELECT Par_ClienteID AS ClienteID,
           Var_ExigDia   AS ExigibleDia,
           Var_TotalDia  AS TotalDia,
           Var_TotalSaldo AS Ahorro;

    END IF;


END TerminaStore$$