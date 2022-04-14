DELIMITER ;
DROP FUNCTION IF EXISTS FNSUMAFECHAXFRECUENCIA;

DELIMITER $$
CREATE FUNCTION `FNSUMAFECHAXFRECUENCIA`(
/* FUNCION QUE SUMA LOS DIAS DE ACUERDO A LA FRECUENCIA */
	Par_Fecha			DATE,		-- Fecha a la cual se le sumaran los días que le llegue por parametro
    Par_Frecuencia      CHAR

) RETURNS date
    DETERMINISTIC
BEGIN
	DECLARE Var_Fecha		DATE;

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);			-- Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia		DATE;				-- Fecha Vacia
    DECLARE FrecQuincenal   CHAR(1);
    DECLARE FrecMensual     CHAR(1);
    DECLARE FrecCatorcenal  CHAR(1);
    DECLARE FrecSemanal     CHAR(1);
    DECLARE FrecQuin        INT(11);
    DECLARE FrecCat         INT(11);
    DECLARE FrecSem         INT(11);

	-- Asignacion de constates
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
    SET FrecQuincenal       := 'Q';
    SET FrecMensual         := 'M';
    SET FrecCatorcenal      := 'C';
    SET FrecSemanal         := 'S';
    SET FrecQuin            := 15;
    SET FrecCat             := 14;
    SET FrecSem             := 7;

    SET Var_Fecha = Fecha_Vacia;

    IF(Par_Frecuencia = FrecQuincenal)THEN
        IF (DAY(Par_Fecha) = FrecQuin) THEN
            SET Var_Fecha  := DATE_ADD(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH), INTERVAL -1 * DAY(Par_Fecha) DAY);
        ELSE
            IF (DAY(Par_Fecha) >28) THEN
                SET Var_Fecha := CONVERT(CONCAT(YEAR(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH)) , '-' ,
                                    MONTH(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH)), '-' , '15'),DATE);
            ELSE
                SET Var_Fecha  := DATE_ADD(DATE_SUB(Par_Fecha, INTERVAL DAY(Par_Fecha) DAY), INTERVAL FrecQuin DAY);
                IF  (Var_Fecha <= Par_Fecha) THEN
                        SET Var_Fecha := CONVERT(CONCAT(YEAR(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH)) , '-' ,
                                                MONTH(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
                END IF;
            END IF;
        END IF;
    END IF;

    IF(Par_Frecuencia = FrecMensual)THEN
        IF (DAY(Par_Fecha)>=28)THEN
            SET Var_Fecha := DATE_ADD(Par_Fecha, INTERVAL 2 MONTH);
            SET Var_Fecha := DATE_ADD(Var_Fecha, INTERVAL -1*CAST(DAY(Var_Fecha)AS SIGNED) DAY);
        ELSE
        -- si no indica que es un numero menor y se obtiene el final del mes.
            SET Var_Fecha:= DATE_ADD(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH), INTERVAL -1 * DAY(Par_Fecha) DAY);
        END IF;
    END IF;

     IF(Par_Frecuencia = FrecCatorcenal)THEN
        IF (DAY(Par_Fecha) = FrecCat) THEN
            SET Var_Fecha  := DATE_ADD(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH), INTERVAL -1 * DAY(Par_Fecha) DAY);
        ELSE
            IF (DAY(Par_Fecha) >28) THEN
                SET Var_Fecha := CONVERT(CONCAT(YEAR(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH)) , '-' ,
                                    MONTH(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH)), '-' , '14'),DATE);
            ELSE
                SET Var_Fecha  := DATE_ADD(DATE_SUB(Par_Fecha, INTERVAL DAY(Par_Fecha) DAY), INTERVAL FrecCat DAY);
                IF  (Var_Fecha <= Par_Fecha) THEN
                        SET Var_Fecha := CONVERT(CONCAT(YEAR(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH)) , '-' ,
                                                MONTH(DATE_ADD(Par_Fecha, INTERVAL 1 MONTH)) , '-' , '14'),DATE);
                END IF;
            END IF;
        END IF;
    END IF;

    IF(Par_Frecuencia = FrecSemanal)THEN
       SET Var_Fecha :=  DATE_ADD(Par_Fecha, INTERVAL FrecSem DAY);
    END IF;
RETURN Var_Fecha;
END$$
