-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONREFERENCIASBANC
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONREFERENCIASBANC`;DELIMITER $$

CREATE FUNCTION `FUNCIONREFERENCIASBANC`(
        Par_CreditoID       BIGINT(12),
        Par_CtaBanamex      INT(11),
        Par_SucursalBanamex INT(11),
        Par_NumCon          INT(11)

) RETURNS char(50) CHARSET latin1
    DETERMINISTIC
BEGIN

DECLARE Var_BanamexSuc      INT(11);
DECLARE Var_CtaBanamex      INT(11);
DECLARE Var_MontoCre        DECIMAL(14,2);
DECLARE Var_FechaVen        DATE;
DECLARE Var_MontoCred       VARCHAR(30);


DECLARE Digito              INT(11);
DECLARE Suma                INT(11);
DECLARE LongitudCred        INT(11);
DECLARE Par                 INT(11);
DECLARE Contador            INT(11);
DECLARE Modulo2             INT(11);
DECLARE UltimoDigito        INT(11);
DECLARE Creditos            CHAR(39);
DECLARE ConBanorte          INT(11);
DECLARE ConBanamex          INT(11);
DECLARE DigitoCred          CHAR(39);
DECLARE K                   CHAR(1);
DECLARE oper_1              INT(11);
DECLARE oper_2              INT(11);
DECLARE oper_3              INT(11);
DECLARE oper_4              INT(11);
DECLARE oper_5              INT(11);
DECLARE oper_6              INT(11);
DECLARE oper_7              INT(11);
DECLARE oper_8              INT(11);
DECLARE oper_9              INT(11);
DECLARE oper_10             INT(11);
DECLARE oper_11             INT(11);
DECLARE oper_12             INT(11);
DECLARE oper_13             INT(11);
DECLARE LongSucBanamex      INT(11);
DECLARE LongCtaBanamex      INT(11);
DECLARE MultiSuc            INT(11);
DECLARE MultiCta            INT(11);
DECLARE ResultadoSuc        INT(11);
DECLARE ResultadoCta        INT(11);
DECLARE Var_BanamexSuc1     CHAR(13);
DECLARE Var_CtaBanamex1     CHAR(13);
DECLARE ResultadoCre        INT(11);
DECLARE Retorno             INT(11);
DECLARE cred                CHAR(13);
DECLARE Entero_Cero         CHAR(1);
DECLARE Total               CHAR(50);
DECLARE Con_Scotiabanck     INT(11);
DECLARE DosMil              INT(11);
DECLARE anio                INT(11);
DECLARE mes                 INT(11);
DECLARE dia                 INT(11);
DECLARE Uno                 INT(11);
DECLARE ConstanteMes        INT(11);
DECLARE ConstanteAnio       INT(11);
DECLARE FechaCondensada     INT(11);
DECLARE ContadorCre         INT(11);
DECLARE MontoCre            VARCHAR(30);
DECLARE MontoDig            INT(11);
DECLARE ConstanteMontoUno   INT(11);
DECLARE ConstanteMontoDos   INT(11);
DECLARE ConstanteMontoTres  INT(11);
DECLARE Referencia          VARCHAR(100);

DECLARE LongitudRef         INT(11);
DECLARE ReferenciaSco       VARCHAR(100);
DECLARE ReferenciaDig       INT(11);
DECLARE ResultadoRef        INT(11);
DECLARE ConstanteScotiabanck CHAR(1);

SET Digito                  :=0;
SET Suma                    :=0;
SET Par                     :=0;
SET Contador                :=0;
SET Modulo2                 :=0;
SET Creditos                :=LPAD(CONVERT(Par_CreditoID, CHAR(39)),39,0);
SET ConBanorte              :=1;
SET ConBanamex              :=2;
SET Con_Scotiabanck         :=3;
SET k                       :='5';

SET oper_1                  :=37;
SET oper_2                  :=31;
SET oper_3                  :=29;
SET oper_4                  :=23;
SET oper_5                  :=19;
SET oper_6                  :=17;
SET oper_7                  :=13;
SET oper_8                  :=11;
SET oper_9                  :=7;
SET oper_10                 :=5;
SET oper_11                 :=3;
SET oper_12                 :=2;
SET oper_13                 :=1;
SET ResultadoSuc            :=0;
SET ResultadoCta            :=0;
SET ResultadoCre            :=0;
SET Entero_Cero             :='0';

SET DosMil                  :=2000;
SET ConstanteAnio           :=372;
SET Uno                     :=1;
SET ConstanteMes            :=31;
SET ConstanteMontoUno       :=7;
SET ConstanteMontoDos       :=3;
SET ConstanteMontoTres      :=1;
SET ResultadoRef            :=0;
SET ConstanteScotiabanck    :='2';



IF(Par_NumCon=ConBanamex)THEN


        SET Var_CtaBanamex :=   Par_CtaBanamex;
        SET Var_BanamexSuc :=   Par_SucursalBanamex;
        SET LongSucBanamex:=LENGTH(Var_BanamexSuc);
        SET LongCtaBanamex:=LENGTH(Var_CtaBanamex);
        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
        SET cred            :=CONVERT(Par_CreditoID, CHAR(13));
        SET LongitudCred    :=LENGTH(cred);
    CICLO :LOOP
    SET Contador :=Contador+1;
        IF(Contador<=13) THEN
            IF(Contador<=LongSucBanamex)THEN

                CASE   WHEN Contador=1 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-1,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_1;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=2 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-2,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_2;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=3 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-3,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_3;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=4 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-4,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_4;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=5 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-5,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_5;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=6 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-6,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_6;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=7 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-7,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_7;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=8 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-8,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_8;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=9 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-9,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_9;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=10 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-10,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_10;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=11 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-11,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_11;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=12 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-12,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_12;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                       WHEN Contador=13 THEN
                        SET Var_BanamexSuc1:=SUBSTRING(Var_BanamexSuc1,-13,1);
                        SET MultiSuc:=CONVERT(Var_BanamexSuc1,UNSIGNED)*oper_13;
                        SET Var_BanamexSuc1 :=CONVERT(Var_BanamexSuc, CHAR(13));
                END CASE;
                SET ResultadoSuc:=ResultadoSuc+MultiSuc;
            END IF;
            IF( Contador<=LongCtaBanamex) THEN

                CASE   WHEN Contador=1 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-1,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_1;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=2 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-2,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_2;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=3 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-3,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_3;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=4 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-4,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_4;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=5 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-5,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_5;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=6 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-6,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_6;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=7 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-7,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_7;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=8 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-8,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_8;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=9 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-9,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_9;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=10 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-10,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_10;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=11 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-11,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_11;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=12 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-12,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_12;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                       WHEN Contador=13 THEN
                        SET Var_CtaBanamex1:=SUBSTRING(Var_CtaBanamex1,-13,1);
                        SET MultiCta:=CONVERT(Var_CtaBanamex1,UNSIGNED)*oper_13;
                        SET Var_CtaBanamex1 :=CONVERT(Var_CtaBanamex, CHAR(13));
                END CASE;
                SET ResultadoCta:=ResultadoCta+MultiCta;
            END IF;
            IF(Contador<=LongitudCred) THEN

                CASE   WHEN Contador=1 THEN
                        SET cred    :=SUBSTRING(cred,-1,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_1;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=2 THEN
                        SET cred    :=SUBSTRING(cred,-2,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_2;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=3 THEN
                        SET cred    :=SUBSTRING(cred,-3,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_3;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=4 THEN
                        SET cred    :=SUBSTRING(cred,-4,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_4;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=5 THEN
                        SET cred    :=SUBSTRING(cred,-5,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_5;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=6 THEN
                        SET cred    :=SUBSTRING(cred,-6,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_6;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=7 THEN
                        SET cred    :=SUBSTRING(cred,-7,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_7;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=8 THEN
                        SET cred    :=SUBSTRING(cred,-8,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_8;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=9 THEN
                        SET cred    :=SUBSTRING(cred,-9,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_9;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=10 THEN
                        SET cred    :=SUBSTRING(cred,-10,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_10;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=11 THEN
                        SET cred    :=SUBSTRING(cred,-11,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_11;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=12 THEN
                        SET cred    :=SUBSTRING(cred,-12,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_12;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                       WHEN Contador=13 THEN
                        SET cred    :=SUBSTRING(cred,-13,1);
                        SET Digito  :=CONVERT(cred,UNSIGNED)*oper_13;
                        SET cred    :=CONVERT(Par_CreditoID, CHAR(13));
                END CASE;
                SET ResultadoCre:=ResultadoCre+Digito;
            END IF;
        ELSE
            LEAVE CICLO;
        END IF;
        END LOOP CICLO;
        SET Suma := ResultadoSuc+ResultadoCta+ResultadoCre;
        SET Retorno:= 99-(Suma % 97);
        IF(Retorno >= 0 AND Retorno <=9) THEN
            SET Total :=CONCAT(Entero_Cero,Retorno);
        ELSE
            SET Total :=CONCAT(CONVERT(Par_CreditoID,CHAR),CONVERT(Retorno,CHAR(2)));
END IF;
        RETURN  Total;
END IF;


IF(Par_NumCon=Con_Scotiabanck)THEN
    SET LongitudCred := LENGTH(Creditos);
    CICLO :LOOP
    SET Contador :=Contador+1;
    SET DigitoCred:=SUBSTRING(Creditos,Contador,1);
    IF(Contador<=LongitudCred) THEN
        SET Modulo2:=Contador%2;
        IF(Modulo2!=Par)THEN
            SET Digito :=CONVERT(DigitoCred, UNSIGNED)*2;
        ELSE
            SET Digito :=CONVERT(DigitoCred,UNSIGNED)*1;
        END IF;
        IF(Digito>9)THEN
            SET Digito := Digito-9;
        END IF;
        SET Suma := Suma+Digito;
    ELSE
      LEAVE CICLO;
    END IF;
    END LOOP CICLO;
    SET UltimoDigito :=Suma%10;
    IF (UltimoDigito=0)THEN
            RETURN CONCAT(CONVERT(Par_CreditoID,CHAR), CONVERT(UltimoDigito,CHAR));
    ELSE
        SET UltimoDigito :=10-UltimoDigito;
        SET UltimoDigito:=CONVERT(UltimoDigito,CHAR(2));
        RETURN CONCAT(CONVERT(Par_CreditoID,CHAR), CONVERT(UltimoDigito,CHAR));
    END IF;
END IF;
END$$