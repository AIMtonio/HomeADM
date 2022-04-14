-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSTIPOSCAMPANIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSTIPOSCAMPANIALT`;DELIMITER $$

CREATE PROCEDURE `SMSTIPOSCAMPANIALT`(
# ========================================================
# ------ SP PARA REGISTRAR LOS TIPOS DE CAMPANIA SMS------
# ========================================================
	Par_Nombre			VARCHAR(50),
	Par_Clasific		CHAR(1),
	Par_Categoria		CHAR(1),

	Par_Salida			CHAR(1),
	INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


	-- Declaracion de Variables
	DECLARE Var_Reserv		CHAR(1);
	DECLARE Var_Clasific	CHAR(1);
	DECLARE Var_Categoria	CHAR(1);
	DECLARE Var_NumTipoCam	INT;
    DECLARE VarControl 		VARCHAR(100);


	-- Declaracion de constantes
	DECLARE Entero_Cero		INT;
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE ReservAplic		CHAR(1);
	DECLARE ReservUsuario	CHAR(1);
	DECLARE ClasifEntrada	CHAR(1);
	DECLARE ClasifSalida	CHAR(1);
	DECLARE ClasifInterac	CHAR(1);
	DECLARE CatEvento		CHAR(1);
	DECLARE CatAutomatica	CHAR(1);
	DECLARE CatCampania		CHAR(1);

	-- Asignacion de constantes
	SET	Entero_Cero			:= 0;		-- Entero Cero
	SET SalidaSI			:= 'S';		-- Salida Si
	SET SalidaNO			:= 'N';		-- Salida No
	SET	Cadena_Vacia		:= '';		-- string Vacio
	SET	ReservAplic			:= 'R';		-- constantes para valor R (reservado de la aplicacion, (campanias que solo agrega efisys))
	SET	ReservUsuario		:= 'U';		-- constantes para valor U (reservado para el usuario)
	SET	ClasifEntrada		:= 'E';		-- Clasificacion= Entrada
	SET	ClasifSalida		:= 'S';		-- Clasificación =Salida
	SET	ClasifInterac		:= 'I';		-- Clasificacion = Interactiva
	SET	CatEvento			:= 'E';		-- Categoria=Evento
	SET	CatAutomatica		:= 'A';		-- Categoria=Automatica
	SET	CatCampania			:= 'C';		-- Categoria=CAmpaña
	SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSTIPOSCAMPANIALT');
			SET VarControl = 'SQLEXCEPTION';
		END;


		IF(IFNULL(Par_Nombre, Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Nombre esta Vacio';
			SET	VarControl 		:= 'nombre';
			SET Var_NumTipoCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Clasific, Cadena_Vacia))= Cadena_Vacia THEN
			SET	 Par_NumErr	 	:= 2;
			SET  Par_ErrMen 	:= 'La Clasificacion esta Vacia';
			SET	VarControl 		:= 'clasificacion';
			SET Var_NumTipoCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Categoria, Cadena_Vacia))= Cadena_Vacia THEN
			SET	 Par_NumErr := 3;
			SET  Par_ErrMen := 'La Categoria esta Vacia';
			SET	VarControl 		:= 'categoria';
			SET Var_NumTipoCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		-- se asigna el valor de el campo reservado de acuerdo a la clasificacion y categoria (U: Usuario, R: Reservado Aplciacion)
		IF(Par_Clasific = ClasifEntrada AND Par_Categoria = CatEvento) THEN
			SET Var_Reserv := ReservAplic;
			ELSE
			IF(Par_Clasific = ClasifSalida AND Par_Categoria = CatAutomatica) THEN
				SET Var_Reserv := ReservAplic;
			ELSE
				IF(Par_Clasific = ClasifSalida AND Par_Categoria = CatCampania) THEN
					SET Var_Reserv := ReservUsuario;
				ELSE
					IF(Par_Clasific = ClasifInterac AND Par_Categoria = CatCampania) THEN
						SET Var_Reserv := ReservUsuario;
					ELSE
						IF(Par_Clasific = ClasifInterac AND Par_Categoria = CatAutomatica) THEN
							SET Var_Reserv := ReservAplic;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;



		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		SET Var_NumTipoCam := (SELECT IFNULL(MAX(TipoCampaniaID),Entero_Cero)+1 FROM SMSTIPOSCAMPANIAS);

		INSERT INTO SMSTIPOSCAMPANIAS (
			TipoCampaniaID,		Nombre,			Clasificacion,		Categoria,			Reservado,
			EmpresaID,			Usuario,		FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES(
			Var_NumTipoCam,		Par_Nombre,		Par_Clasific,		Par_Categoria,		Var_Reserv,
			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);


		SET	 Par_NumErr := 0;
		SET  Par_ErrMen :=  CONCAT("Tipo Campania Agregado Exitosamente: ", CONVERT(Var_NumTipoCam, CHAR));


	END ManejoErrores;  -- END del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'tipoCampaniaID' AS control,
				Var_NumTipoCam AS consecutivo;

	END IF;

END TerminaStore$$