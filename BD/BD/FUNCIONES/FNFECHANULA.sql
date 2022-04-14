DELIMITER ;
DROP FUNCTION IF EXISTS FNFECHANULA;

DELIMITER $$
CREATE FUNCTION `FNFECHANULA`(
Par_Fecha		VARCHAR(20)		# Feecha a la que se le sumaran los días habiles.
) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN
	DECLARE Var_FechaResp  DATE;
	DECLARE Var_FechaVacia DATE;
	
    SET Var_FechaVacia	:= '1900-01-01';
    
    IF Par_Fecha regexp '^([1-2]{1}[0-9]{3})-([0-1][0-9])-([0-3][0-9])' THEN
		SET Var_FechaResp	:= Par_Fecha;
    ELSE
		SET Var_FechaResp	:= Var_FechaVacia;
    END IF;
    
    SET Var_FechaResp := IFNULL(Var_FechaResp,Var_FechaVacia);
	
    RETURN Var_FechaResp;
END$$
