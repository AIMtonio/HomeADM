-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEATARJETACREDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEATARJETACREDLIS`;DELIMITER $$

CREATE PROCEDURE `LINEATARJETACREDLIS`(
-- 	SP PARA LISTAS DE LINEAS DE CREDITO
	Par_NombreComp		VARCHAR(50), 		-- Nombre completo
    Par_ClienteID		INT(11),			-- Cliente
	Par_NumLis			TINYINT UNSIGNED,   -- Numero de consulta

	Aud_EmpresaID		INT(11), 			-- Auditoria
	Aud_Usuario			INT(11),			-- Auditoria
	Aud_FechaActual		DATETIME, 			-- Auditoria
	Aud_DireccionIP		VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID		VARCHAR(50), 		-- Auditoria
	Aud_Sucursal		INT(11), 			-- Auditoria
	Aud_NumTransaccion	BIGINT(20) 			-- Auditoria
)
TerminaStore: BEGIN

	#Declaracion de  variables
	DECLARE Var_Sentencia 		VARCHAR(4000);

	#Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Est_Activo			CHAR(1);
	DECLARE	Est_Bloquea			CHAR(1);

	DECLARE  Est_Cancelada      CHAR(1);
	DECLARE	Lis_Principal 		INT(11);
    DECLARE	Lis_Num_Cte 		INT(11);
    DECLARE Lis_Lineas_Cte		INT(11);
    DECLARE DesctarjetaCred		VARCHAR(20);


    /*ASIGNACION DE CONSTANTES*/
	SET	Cadena_Vacia			:=	'';
	SET	Fecha_Vacia				:=	'1900-01-01';
	SET	Entero_Cero				:=	0;
	SET	Est_Activo				:=	'A';			    # ESTATUS ACTIVO
	SET	Est_Bloquea				:=	'B';			    # ESTATUS BLOQUEADO
	SET DesctarjetaCred			:=  'TARJETA CREDITO';  # DESCRIPCION DE LA TARJETA
	SET Est_Cancelada			:=	'C';    			# ESTATUS CANCELADA
	SET	Lis_Principal			:=	1;  				# Muestra todas las cuentas del cliente excepto canceladas
	SET Lis_Num_Cte 		    := 	2;					# Muestra todas las cuentas del cliente activas
    SET	Lis_Lineas_Cte			:=	3;					# Muestra todas lacuentas del cliente exepto las canceladas mediante el nombre completo del cliente




	/* muestra todas las cuentas del cliente excepto canceladas*/
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	LC.LineaTarCredID,	DesctarjetaCred AS Descripcion
			FROM LINEATARJETACRED	LC
			WHERE	LC.ClienteID	=	Par_ClienteID
				AND	LC.Estatus	<>	Est_Cancelada
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_Num_Cte) THEN
		SELECT 	LC.LineaTarCredID,  DesctarjetaCred AS Descripcion
			FROM LINEATARJETACRED	LC
			WHERE	LC.ClienteID	=	Par_ClienteID
			AND	LC.Estatus	= 	Est_Activo
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_Lineas_Cte) THEN
		SELECT	LC.LineaTarCredID,	CTE.NombreCompleto,	DesctarjetaCred AS Descripcion
			FROM LINEATARJETACRED	LC
			INNER JOIN	CLIENTES	CTE	ON	CTE.NombreCompleto	LIKE	CONCAT("%", Par_NombreComp, "%")	AND	CTE.Estatus!='I'
			AND	LC.ClienteID	=	CTE.ClienteID
			AND	LC.Estatus	<>	Est_Cancelada
			LIMIT 0, 15;
	END IF;


END TerminaStore$$