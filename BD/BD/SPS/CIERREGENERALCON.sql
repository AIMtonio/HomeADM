-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREGENERALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREGENERALCON`;DELIMITER $$

CREATE PROCEDURE `CIERREGENERALCON`(
# =====================================================================================
# ------- STORED PARA CONSULTA DEL CIERRE GENERAL ---------
# =====================================================================================
   	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_FechaSis 		DATE;				-- Fecha del sistema
    DECLARE Var_FechaCierreAnt	DATE;				-- Fecha del utimo cierre realizado
    DECLARE Var_FechaHoraUltCie DATETIME;			-- Fecha y hora del ciere anterior
    DECLARE Var_ConfirmaCierre 	CHAR(1);			-- s= si muestra confirmara para realizar el cierre , n no muestra validacion
    DECLARE Var_MsjValida		VARCHAR(500);		-- Mensaje d valiacion de cierre
    DECLARE Var_TiempoUltimoCierre VARCHAR(30);
    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    DECLARE Con_RealizaCierre	INT(11);
    DECLARE Hrs_Espera			TIME;				-- Horas que deben transucrrir para realizar sig cierre y no mostrar msj de confirmación en pantalla

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Con_RealizaCierre		:= 1;
    SET Hrs_Espera				:= '08:00:00';				-- Horas que deben transucrrir para realizar sig cierre y no mostrar msj de confirmación en pantalla

	-- Consulta  1
	IF(Par_NumCon = Con_RealizaCierre) THEN
		SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_MsjValida := '';

        -- Obtenemos la fecha del ultimo cierre que se realizo en dia habil
        SET Var_FechaCierreAnt :=(	SELECT MAX(Fecha)
									FROM BITACORABATCH
									WHERE ProcesoBatchID = 900); -- Proceso cierre general fin

        -- Obtenemos la maxima hora en que realizo el ultimo proceso del cierre anterior
        SET Var_FechaHoraUltCie := (SELECT MAX(FechaActual)
									FROM BITACORABATCH
									WHERE Fecha = Var_FechaCierreAnt);

		-- Obtenemos las horas que transcurrieron despues de realizar el ultimo cierre a este momento
        SET Var_TiempoUltimoCierre := TIMEDIFF(NOW(), Var_FechaHoraUltCie);

		SET Var_ConfirmaCierre := 'S';

        -- Si la fecha del sistema es mayor a la actual
        -- se debe confirmar que se realiza este cierre
        IF(Var_FechaSis > DATE(NOW()))THEN

			SET Var_MsjValida := CONCAT('Estimado Usuario: El cierre del día ',
				(ELT(WEEKDAY(NOW()) + 1, 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')),
				' ',DATE(NOW()),' ya fue realizado.\n');

        END IF;

        SET Var_MsjValida := CONCAT(Var_MsjValida, ' \n¿Desea realizar el Cierre del Día ',
			(ELT(WEEKDAY(Var_FechaSis) + 1, 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')),
            ' ',Var_FechaSis,'?	');

        SELECT Var_ConfirmaCierre AS ConfirmaCierre, Var_MsjValida AS MsjValida, Var_FechaCierreAnt AS FechaCierreAnt, Var_FechaHoraUltCie AS FechaHoraUltCie, Var_TiempoUltimoCierre AS TiempoUltimoCierre;

	END IF;

END TerminaStore$$