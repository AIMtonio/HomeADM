-- FNGENERACODIGOOXXO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGENERACODIGOOXXO`;
DELIMITER $$
CREATE FUNCTION `FNGENERACODIGOOXXO`(
	Par_CreditoID BIGINT(20),
	Par_ClienteID	INT(11)
) RETURNS VARCHAR(22)
	DETERMINISTIC
BEGIN
	DECLARE Var_Referencia	VARCHAR(50);
    
    SET Var_Referencia := (SELECT Referencia 
    FROM REFPAGOSXINST R INNER JOIN INSTITUCIONES I
    ON R.InstitucionID = I.InstitucionID
    WHERE I.AlgoritmoID = 3
	AND R.InstrumentoID = Par_CreditoID );
   RETURN  Var_Referencia;

END$$
