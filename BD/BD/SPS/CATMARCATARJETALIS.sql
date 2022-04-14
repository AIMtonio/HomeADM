
-- CATMARCATARJETALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMARCATARJETALIS`;

DELIMITER $$
CREATE PROCEDURE `CATMARCATARJETALIS`(
	# =====================================================================================
	# ------- STORED PARA CONSULTA LISTA DE BIN ---------
	# =====================================================================================
	Par_CatMarcaTarjetaID   INT(11),        	-- Idetinficador de la tabla
	Par_NumCon          	TINYINT UNSIGNED,   -- Numero de consulta

	Par_EmpresaID           INT(11),        	-- Parametro de auditoria ID de la empresa
	Aud_Usuario             INT(11),        	-- Parametro de auditoria ID del usuario
	Aud_FechaActual         DATETIME,       	-- Parametro de auditoria Fecha actual
	Aud_DireccionIP         VARCHAR(15),    	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID          VARCHAR(50),    	-- Parametro de auditoria Programa
	Aud_Sucursal            INT(11),        	-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion      BIGINT(20)      	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES


	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia        CHAR(1);            -- Constante cadena vacia ''
	DECLARE Fecha_Vacia         DATE;               -- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero         INT(1);             -- Constante Entero cero 0
	DECLARE Decimal_Cero        DECIMAL(14,2);      -- DECIMAL cero
	DECLARE Con_Combo	       INT(11);            -- Consulta 1: Principal

	DECLARE Cons_SI             CHAR(1);
	DECLARE Cons_NO             CHAR(1);

	-- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia            := '';
	SET Fecha_Vacia             := '1900-01-01';
	SET Entero_Cero             := 0;
	SET Decimal_Cero            := 0.0;
	SET Con_Combo           	:= 3;

	SET Cons_SI                 := 'S';
	SET Cons_NO                 := 'N';

	-- Consulta 1
	IF(Par_NumCon = Con_Combo) THEN

		SELECT  catMarcaTarjetaID,	Descripcion
		FROM CATMARCATARJETA;

	END IF;

END TerminaStore$$