-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDIRECCIONESCLIENTESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDIRECCIONESCLIENTESALT`;
DELIMITER $$


CREATE PROCEDURE `PLDDIRECCIONESCLIENTESALT`(
	-- SP para dar de alta las direcciones de los Clietnes Externos al SAFI
	Par_TipoOperacion		CHAR(2),			-- Tipo de operacion  AD = Alta Direccion, MD = Modifica direccion
	Par_ClienteIDExt		VARCHAR(20),		-- CLIENTE ID EXTERNO
	Par_TipoDirecID			INT(11),			-- TIPO DIREC
	Par_EstadoID			INT(11),			-- ESTADO
	Par_MunicipioID			INT(11),			-- MUNICIPIO
	Par_LocalidadID			INT(11),			-- LOCALIDAD

	Par_ColoniaID			INT(11),			-- COLINIA
	Par_NombreColonia		VARCHAR(200),		-- NOMBRE COLONIA
	Par_Calle				VARCHAR(350),		-- CALLE
	Par_NumeroCasa			CHAR(10),			-- CASA NUMERO
	Par_NumInterior			CHAR(10),			-- NUM INTERIOR

	Par_Piso				CHAR(50),			-- PISO
	Par_PrimECalle			VARCHAR(50),		-- CALLE
	Par_SegECalle			VARCHAR(50),  		-- SEGUNDA CALLE
	Par_CP					CHAR(5),			-- CP
	Par_Descripcion			VARCHAR(500),		-- DESCRIPCION

	Par_Latitud				VARCHAR(45),		-- LATITUD
	Par_Longitud			VARCHAR(45),		-- LONGITUD
	Par_Oficial				CHAR(1),			-- OFICIAL
	Par_Fiscal				CHAR(1),			-- FISCAL
	Par_Lote				CHAR(50),			-- LOTE

	Par_Manzana				CHAR(50),			-- MANZANA
	Par_Salida				CHAR(1), 			-- SALIDA
	INOUT Par_NumErr		INT(11),			-- NUM ERROR
	INOUT Par_ErrMen		VARCHAR(400),		-- ERR MEN
	INOUT Par_DirecID		INT(11),			-- DIREC

	Aud_EmpresaID			INT(11),			-- AUDITORIA
	Aud_Usuario				INT(11),			-- AUDITORIA
	Aud_FechaActual			DATETIME,			-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal			INT(11),			-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)			-- AUDITORIA
)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- CADENA VACIA
	DECLARE Fecha_Vacia			DATE;			-- FECHA VACIA
	DECLARE Entero_Cero			INT;			-- ENTERO CERO
	DECLARE Salida_SI			CHAR(1);		-- SALIDA SI
	DECLARE Salida_NO			CHAR(1);		-- SALIDA NO

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(25);	-- CONTROL
	DECLARE Var_DireccionID			INT(11);		-- NUMERO DIREC
	DECLARE Var_ClienteID			INT(11);		-- NUMERO DEL CLIENTE EN EL SAFI
	DECLARE Var_OpAltaDirecc		CHAR(2);		-- Operacion alta direccion
	DECLARE Var_OpModificaDirecc	CHAR(2);		-- Operacion Modifica direccion

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Salida_SI			:= 'S';				-- Salida SI
	SET Salida_NO			:= 'N';				-- Salida No
	SET Var_OpAltaDirecc		:= 'AD';			-- Alta direccion
	SET Var_OpModificaDirecc	:= 'MD';			-- Modifica direccion

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDDIRECCIONESCLIENTESALT');
		END;
		
		IF(Par_TipoOperacion = Cadena_Vacia) THEN
				SET Par_NumErr	:=   003;
				SET Par_ErrMen	:= 'El tipo de operacion se ecuentra vacio';
				SET Var_Control	:= 'clienteID';
				LEAVE ManejoErrores;
		END IF;
		
		IF(Par_TipoOperacion != Var_OpAltaDirecc AND Par_TipoOperacion != Var_OpModificaDirecc) THEN
				SET Par_NumErr	:=   004;
				SET Par_ErrMen	:= 'El tipo de operacion no es valido';
				SET Var_Control	:= 'clienteID';
				LEAVE ManejoErrores;
		END IF;
		
		SET Par_ClienteIDExt	:= IFNULL(Par_ClienteIDExt,Cadena_Vacia);

		IF(Par_ClienteIDExt = Cadena_Vacia) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Numero del Cliente se encuentra vacio.' ;
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SELECT ClienteID
		INTO Var_ClienteID
		FROM PLDCLIENTES
		WHERE ClienteIDExt = Par_ClienteIDExt;

		SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);

		IF (Var_ClienteID = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El Numero del Cliente no existe.' ;
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;
		
		-- Registro de direcciones
		IF(Par_TipoOperacion = Var_OpAltaDirecc) THEN
		
			CALL DIRECCIONCTEALT(
				Var_ClienteID,		Par_TipoDirecID,		Par_EstadoID,		Par_MunicipioID,		Par_LocalidadID,
				Par_ColoniaID,		Par_NombreColonia,		Par_Calle,			Par_NumeroCasa,			Par_NumInterior,
				Par_Piso,			Par_PrimECalle,			Par_SegECalle,		Par_CP,					Par_Descripcion,
				Par_Latitud,		Par_Longitud,			Par_Oficial,		Par_Fiscal,				Par_Lote,
				Par_Manzana,		Salida_NO,				Par_NumErr,			Par_ErrMen,				Par_DirecID,
				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			INSERT INTO PLDDIRECCIONESCLIENTES(
				ClienteIDExt,		ClienteID,			DireccionID,		EmpresaID,		Usuario,
				FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
			) VALUES (
				Par_ClienteIDExt,	Var_ClienteID,		Par_DirecID,	Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
			);
			
			SET Par_ErrMen := CONCAT('Direccion Agregada Exitosamente: ', CONVERT(Par_DirecID, CHAR));
		END IF;
		
		-- Modificacion de direccion
		IF(Par_TipoOperacion = Var_OpModificaDirecc) THEN

			IF(IFNULL(Par_DirecID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'Numero de direccion es requerido' ;
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			SELECT DireccionID
			INTO Par_DirecID
			FROM PLDDIRECCIONESCLIENTES
			WHERE ClienteIDExt = Par_ClienteIDExt
				AND DireccionID = Par_DirecID;

			IF(IFNULL(Par_DirecID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'No se encontro la direccion con el numero de cliente.' ;
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
			END IF;

		
			CALL DIRECCIONCTEMOD(
				Var_ClienteID,      Par_DirecID,    Par_TipoDirecID,    Par_EstadoID,   Par_MunicipioID,
				Par_LocalidadID,    Par_ColoniaID,  Par_NombreColonia,  Par_Calle,      Par_NumeroCasa,
				Par_NumInterior,    Par_Piso,       Par_PrimECalle,     Par_SegECalle,  Par_CP,
				Par_Descripcion,    Par_Latitud,    Par_Longitud,       Par_Oficial,    Par_Fiscal,
				Par_Lote,           Par_Manzana,    Salida_NO,          Par_NumErr,     Par_ErrMen,
				Par_DirecID,        Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion );
				
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
			
			SET Par_ErrMen := CONCAT('Direccion Modificado Exitosamente: ', CONVERT(Par_DirecID, CHAR));
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Var_Control := 'direccionID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_DirecID AS Consecutivo;
	END IF;

END TerminaStore$$
