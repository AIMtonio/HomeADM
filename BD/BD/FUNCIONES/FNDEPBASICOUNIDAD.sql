DELIMITER ;
DROP FUNCTION IF EXISTS FNDEPBASICOUNIDAD;
DELIMITER $$

CREATE FUNCTION FNDEPBASICOUNIDAD(
	-- Descripcion: Proceso para retornar el id de promotores correspondientes dependientes al usuario
	-- Modulo: Cartera(Operacion Basica de Unidad)
	Par_UsuarioID		INT(11)
) RETURNS VARCHAR(1000) CHARSET latin1
	DETERMINISTIC
BEGIN
	-- 	DECLARACION DE VARIABLES
	DECLARE Var_LisUsuarios		VARCHAR(1000);		-- Lista de usuarios
	DECLARE Var_UsuarioID		INT(11);			-- Identificador de usuarios
	DECLARE Var_EmpleadoHijo 	VARCHAR(500);		-- Empleado
	DECLARE Var_UsuariosHijo 	VARCHAR(500);		-- Usuarios dependiente
	DECLARE Var_EmpleadosBusca 	VARCHAR(500);		-- Empleado a buscar
	DECLARE Var_AuxEmpleado		VARCHAR(100);		-- Auxiliar de empleado
	DECLARE Var_EmpeadoID		BIGINT(20);			-- Identificador del empleado
	DECLARE Var_AuxUsuarioID	INT(11);			-- Almacena el usuario ID
	DECLARE Var_PromotorID		INT(11);			-- Identificador del promotor
	DECLARE Var_ListaPromotores	VARCHAR(1000);		-- Lista de promotores
	DECLARE Var_PromotoresBusca	VARCHAR(500);		-- Busqueda de promotores

	 -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia ''
	DECLARE Fecha_Vacia 		DATE;				-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero 		INT(1); 			-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI			CHAR(1);			-- Parametro de salida SI

	DECLARE Entero_Uno			INT(11);			-- Entero Uno
	DECLARE Cons_Coma			CHAR(1);			-- Constante coma

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI				:= 'S';

	SET Entero_Uno				:= 1;
	SET Cons_Coma				:= ',';

	SET Var_EmpleadoHijo		:= '';

	-- INICIA LA LISTA DE USUARIO CON EL USUARIO QUE SE MANDA DE PARAMETRO
	SET Var_LisUsuarios 		:= Par_UsuarioID;

	-- BUSCA EL ID DE EMPLEADO DEL USUARIO
	SET Var_EmpeadoID := (SELECT EmpleadoID FROM USUARIOS WHERE UsuarioID = Par_UsuarioID);
	SET Var_EmpeadoID := IFNULL(Var_EmpeadoID,Entero_Cero);

	-- SI TIENE RELACIONADO UN EMPLEADO SE BUSCARAN SUS DEPENDENCIAS
	IF(IFNULL(Var_EmpeadoID,Entero_Cero) > Entero_Cero)THEN
		-- INICIA CADENA PARA BUSCAR DEPENDENCIAS DEL EMPLEADO
		SET Var_EmpleadosBusca := Var_EmpeadoID;

		-- MIENTRAS EXISTAN EMPLEADOS POR BUSCAR
		WHILE(Var_EmpleadosBusca <> Cadena_Vacia)DO
			-- OBTENEMOS EL EMPLEADO A BUSCAR
			SET Var_AuxEmpleado := SUBSTRING_INDEX(Var_EmpleadosBusca,Cons_Coma,Entero_Uno);

			-- SI ENCONTRO UN EMPLEADO A BUSCAR
			IF(Var_AuxEmpleado <> Cadena_Vacia)THEN
				SET Var_UsuarioID := CAST(Var_AuxEmpleado AS UNSIGNED INTEGER);
			ELSE
				SET Var_UsuarioID := Entero_Cero;
			END IF;

			SELECT	GROUP_CONCAT(ORG.PuestoHijoID),	GROUP_CONCAT(USU.UsuarioID)
			INTO	Var_EmpleadoHijo,					Var_UsuariosHijo
			FROM ORGANIGRAMA ORG
				LEFT JOIN
					USUARIOS USU ON ORG.PuestoHijoID = USU.EmpleadoID
			WHERE PuestoPadreID = Var_UsuarioID;

			SET Var_EmpleadoHijo := IFNULL(Var_EmpleadoHijo, Cadena_Vacia);
			SET Var_UsuariosHijo := IFNULL(Var_UsuariosHijo, Entero_Cero);

			-- SI ENCUENTRO DEPENDIENTES DEL EMPLEADO
			IF(IFNULL(Var_EmpleadoHijo,Cadena_Vacia) <> Cadena_Vacia)THEN
				SET Var_LisUsuarios		:= CONCAT(Var_LisUsuarios , Cons_Coma , Var_UsuariosHijo);
				SET Var_EmpleadosBusca	:= CONCAT(Var_EmpleadosBusca , Cons_Coma , Var_EmpleadoHijo);
			END IF;

			 -- EL EMPLEADO SE QUITA DE LA LISTA A BUSCAR
			SET Var_EmpleadosBusca := SUBSTR(Var_EmpleadosBusca, (CHAR_LENGTH(Var_AuxEmpleado)+2),CHAR_LENGTH(Var_EmpleadosBusca));

		END WHILE;
	END IF;

	-- Se evalua que la lista que se llena traiga datos
	IF(Var_LisUsuarios <> Cadena_Vacia)THEN
		SET Var_PromotoresBusca	:= Var_LisUsuarios;
		SET Var_ListaPromotores	:= Entero_Cero;

		-- Se busca el primer empleado
		WHILE (Var_PromotoresBusca <> Cadena_Vacia)DO
			-- INICIALIZACION DE DATOS PARA EL CICLO
			SET Var_AuxUsuarioID 	:= Entero_Cero;
			SET Var_PromotorID		:= Entero_Cero;

			-- SE OBTIENE EL PRIMER PROMOTOR
			SET Var_AuxUsuarioID 	:= CAST(SUBSTRING_INDEX(Var_PromotoresBusca,Cons_Coma,Entero_Uno) AS UNSIGNED);
			-- EVALUDACION EN CASO DE SER NULO
			SET Var_AuxUsuarioID 	:= IFNULL(Var_AuxUsuarioID, Entero_Cero);

			-- SE OBTIENE EL ID DE PROMOTOR
			SELECT 	PromotorID
			INTO	Var_PromotorID
			FROM PROMOTORES
			WHERE UsuarioID = Var_AuxUsuarioID;

			SET Var_PromotorID := IFNULL(Var_PromotorID, Entero_Cero);
			-- CUANDO EL PROMOTOR SEA MAYOR A CERO
			IF(Var_PromotorID > Entero_Cero)THEN
				SET Var_ListaPromotores := CONCAT(Var_ListaPromotores, Cons_Coma, Var_PromotorID);
			END IF;

			 -- PROMOTOR SE QUITA DE LA CADENA
			SET Var_PromotoresBusca := SUBSTR(Var_PromotoresBusca, (CHAR_LENGTH(Var_AuxUsuarioID)+2),CHAR_LENGTH(Var_PromotoresBusca));
		END WHILE;
	ELSE
		RETURN Cadena_Vacia;
	END IF;

RETURN Var_ListaPromotores;
END$$