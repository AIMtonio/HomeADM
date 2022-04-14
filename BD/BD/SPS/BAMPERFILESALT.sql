-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPERFILESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPERFILESALT`;DELIMITER $$

CREATE PROCEDURE `BAMPERFILESALT`(
  -- SP para dar de alta un perfilen la banca electronica

	Par_NombrePerfil		VARCHAR(60),   	-- NOMBRE DEL PERFIL PARA LA BANCA MOVIL
	Par_Descripcion			VARCHAR(100),  	-- DESCRIPCION DEL PERFIL
	Par_AccesoConToken   	CHAR(1),       	-- ES REQUERIDO EL ACCESO CON TOKEN S.-SI N.-NO
	Par_TransacConToken		CHAR(1),      	-- ES REQUERIDO TOKEN PARA TRANSACCION S.-SI N.-NO
	Par_CostoPrimeraVez    	DECIMAL(12,2), 	-- COSTO DE ACTIVAR SERVICIO DE BANCA MOVIL
	Par_CostoMensual	    DECIMAL(12,2), 	-- COSTO MENSUAL DEL SERVICIO

	Par_Salida          	CHAR(1),		-- INDICA SI EL SP GENERA O NO UNA SALIDA
    INOUT Par_NumErr    	INT(11),			-- PARAMETRO DE SALIDA CON EL NUMERO DE ERROR
    INOUT Par_ErrMen    	VARCHAR(400),	-- PARAMETRO DE SALIDA CON EL MENSAJE DE ERROR

	Par_EmpresaID			INT(11),	   	-- AUDITORIA
	Aud_Usuario				INT(11),		-- AUDITORIA
	Aud_FechaActual			DATETIME,		-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal			INT(11),		-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)		-- AUDITORIA
	)
TerminaStore: BEGIN

-- Declaracion de variables
	DECLARE	Var_PerfilID	INT;          -- ID consecutivo
	DECLARE Var_Control     VARCHAR(50); -- Variable de control

-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);      -- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;         -- Fecha vacia
	DECLARE	Entero_Cero		INT;          -- Entero cero
	DECLARE SalidaSI        CHAR(1);	 -- Genera una salida

-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Entero 0
	SET SalidaSI        	:= 'S';             -- El Store SI genera una Salida

-- Handler manejo de errores
ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMPERFILESALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

	IF(IFNULL(Par_NombrePerfil,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr :=001;
		SET Par_ErrMen	 :='El Nombre esta Vacio.' ;
		SET Var_Control	 := 'nombrePerfil';
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr :=002 ;
		SET Par_ErrMen :='La Descripcion esta Vacia.';
		SET Var_Control := 'descripcion' ;
	LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_AccesoConToken, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr 	:= 003;
		SET	Par_ErrMen	:= 'Campo Acceso con Token Vacio';
		SET Var_Control := 'accesoConToken';
		LEAVE ManejoErrores;
	END IF;
		IF(IFNULL(Par_TransacConToken, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr 	:= 004;
		SET	Par_ErrMen	:= 'Campo Transaccion con Token esta Vacio';
		SET Var_Control := 'transaccionConToken';
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_CostoPrimeraVez, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr 	:= 005;
		SET	Par_ErrMen	:= 'El Costo por Primera Vez esta Vacio';
		SET Var_Control := 'costoPrimeraVez';
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_CostoMensual, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr 	:= 006;
		SET	Par_ErrMen	:= 'El Costo Mensual esta Vacio';
		SET Var_Control := 'costoMensual';
		LEAVE ManejoErrores;
	END IF;



	SET Var_PerfilID 		:= (SELECT IFNULL(MAX(PerfilID),Entero_Cero) + 1
						FROM BAMPERFILES);

	CALL FOLIOSAPLICAACT('BAMPERFILES', Var_PerfilID);
	SET Aud_FechaActual 	:= NOW();


	INSERT INTO  BAMPERFILES(PerfilID,			  NombrePerfil,		Descripcion,	AccesoConToken,	    TransacConToken,
							 CostoPrimeraVez,	  CostoMensual,		EmpresaID,		Usuario,			FechaActual,
							 DireccionIP,		  ProgramaID,		Sucursal,	    NumTransaccion)
	VALUES(
							 Var_PerfilID,		  Par_NombrePerfil, Par_Descripcion,Par_AccesoConToken,	Par_TransacConToken,
							 Par_CostoPrimeraVez, Par_CostoMensual, Par_EmpresaID,  Aud_Usuario,		Aud_FechaActual,
							 Aud_DireccionIP,     Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT("Perfil Agregado Exitosamente: ", CONVERT(Var_PerfilID, CHAR)) ;
			SET Var_Control := 'perfilID';

	END ManejoErrores; -- END del handler manejo de errores
            IF (Par_Salida = SalidaSI) THEN

			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					IFNULL(Var_PerfilID, Entero_Cero) AS consecutivo;
			END IF;
END TerminaStore$$