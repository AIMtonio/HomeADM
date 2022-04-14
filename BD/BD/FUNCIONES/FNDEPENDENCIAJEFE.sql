DELIMITER ;
DROP FUNCTION IF EXISTS FNDEPENDENCIAJEFE;
DELIMITER $$

CREATE FUNCTION FNDEPENDENCIAJEFE(
	-- Descripcion: Proceso para retornar el id del coordinador con base a un promotor
	-- Modulo: Cartera(Operacion Basica de Unidad)
	Par_PromotorID		INT(11)						-- Numero del promotor
) RETURNS INT(11)
	DETERMINISTIC
BEGIN
	-- 	DECLARACION DE VARIABLES
	DECLARE Var_CoordinadorID	INT(11);			-- Numero del coordinador
	DECLARE Var_EmpleadoID		INT(11);			-- Numero de empleado
	DECLARE Var_RolID			INT(11);			-- Rol del usuario
	DECLARE Var_RolCoordinador	INT(11);			-- Identificador el numero de rol de coordinador
	DECLARE Var_UsuarioID		INT(11);			-- Id del usuario
	DECLARE Var_EmpleadoJefe	INT(11);			-- Id del empleado jefe

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

	SET Var_CoordinadorID		:= 0;

	-- SE OBTIENE EL NUMERO DE ROL CORRESPONDIENTE AL COORDINADOR
	SET Var_RolCoordinador		:= CAST( IFNULL(FNPARAMGENERALES('RolCoordinador'), Entero_Cero) AS UNSIGNED);

	-- SE OBTIENE EL ID DEL EMPLEADO CON BASE AL PROMOTOR
	SELECT	Us.EmpleadoID,		Rol.RolID,	Prom.UsuarioID
	INTO	Var_EmpleadoID,		Var_RolID,	Var_UsuarioID
	FROM PROMOTORES Prom
	INNER JOIN USUARIOS Us ON Prom.UsuarioID = Us.UsuarioID
	INNER JOIN ROLES Rol ON Us.RolID = Rol.RolID
	WHERE Prom.PromotorID = Par_PromotorID;

	-- VALIDACION DE DATOS NULOS
	SET Var_EmpleadoID	:= IFNULL(Var_EmpleadoID, Entero_Cero);
	SET Var_RolID		:= IFNULL(Var_RolID, Entero_Cero);
	SET Var_UsuarioID	:= IFNULL(Var_UsuarioID, Entero_Cero);

	-- SE VALIDA SI EL PROMOTOR ACTUAL ES UN COORDINADOR
	IF(Var_RolID = Var_RolCoordinador)THEN
		SET Var_CoordinadorID := Var_UsuarioID;
		RETURN Var_CoordinadorID;
	END IF;

	-- SE VALIDA QUE SEA UN EMPLEADO
	IF(Var_EmpleadoID <> Entero_Cero)THEN
		-- SE OBTIENE EL JEFE INMEDIATIO
		SELECT	J.EmpleadoID
		INTO	Var_EmpleadoJefe
		FROM EMPLEADOS E
		INNER JOIN PUESTOS P ON E.ClavePuestoID = P.ClavePuestoID
		LEFT JOIN ORGANIGRAMA O ON E.EmpleadoID = O.PuestoHijoID
		LEFT JOIN EMPLEADOS J ON O.PuestoPadreID = J.EmpleadoID
		LEFT JOIN CATEGORIAPTO C ON P.CategoriaID = C.CategoriaID
		WHERE E.EmpleadoID = Var_EmpleadoID;

		-- VALIDACION DE DATOS NULOS
		SET Var_EmpleadoJefe := IFNULL(Var_EmpleadoJefe, Entero_Cero);

		-- SE OBTIENE EL ID DEL EMPLEADO JEFE
		SELECT	UsuarioID
		INTO	Var_CoordinadorID
		FROM USUARIOS
		WHERE EmpleadoID = Var_EmpleadoJefe;

		-- VALIDACION DE DATOS NULOS
		SET Var_CoordinadorID := IFNULL(Var_CoordinadorID, Entero_Cero);
	ELSE
		-- SE RETORNA CERO
		SET Var_CoordinadorID := Entero_Cero;
		RETURN Var_CoordinadorID;
	END IF;


RETURN Var_CoordinadorID;
END$$