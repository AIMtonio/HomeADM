-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSACTIVOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSACTIVOSPRO`;

DELIMITER $$
CREATE PROCEDURE `FOLIOSACTIVOSPRO`(
	-- Store Procedure para Actualizar los folios por Tipo de Activos
	-- Modulo Activos --> Taller de Producto --> Tipos Activos
	Par_TipoActivoID		INT(11),		-- Idetinficador del tipo de activo
	Par_FechaRegistro		DATE,			-- Fecha de Registro
	INOUT Par_Consecutivo	CHAR(11),		-- Idetinficador del tipo de activo

	Par_Salida				CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de salida mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Consecutivo		INT(11);			-- Variable consecutivo
	DECLARE Var_Folio			INT(11);			-- Variable Numero de Folio
	DECLARE Var_Mes				CHAR(2);		-- Mes de Registro
	DECLARE Var_Anio			CHAR(2);		-- Anio de Registro
	DECLARE Var_ClaveTipoActivo	CHAR(3);			-- Clave de Tipo Activo

	DECLARE Var_Control			VARCHAR(100);		-- Variable de Control

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha vacia
	DECLARE Entero_Cero			INT(1);				-- Constante Entero cero
	DECLARE Entero_Uno			INT(11);			-- Constante Entero Uno
	DECLARE Con_Validador		INT(11);			-- Numero de Validador
	DECLARE Con_LongitudFolio	INT(11);			-- Longitud de Folio

	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia
	DECLARE Salida_SI			CHAR(1);			-- Constante de salida SI
	DECLARE Salida_NO			CHAR(1);			-- Constante de salida NO
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante Decimal cero

	-- Declaracion de Actualizaciones
	DECLARE Act_FolioActivo		TINYINT UNSIGNED;	-- Actualiza Folio Activo

	-- Asignacion de Constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Con_Validador			:= 4;
	SET Con_LongitudFolio		:= 11;

	SET Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET Decimal_Cero			:= 0.0;

	-- Asignacion de Actualizaciones
	SET Act_FolioActivo			:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-FOLIOSACTIVOSPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Par_TipoActivoID  := IFNULL(Par_TipoActivoID, Entero_Cero);
		SET Par_FechaRegistro := IFNULL(Par_FechaRegistro, Fecha_Vacia);

		IF( Par_TipoActivoID = Entero_Cero ) THEN
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'El Tipo de Activo esta Vacio';
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT TipoActivoID FROM TIPOSACTIVOS WHERE Par_TipoActivoID ) THEN
			SET Par_NumErr 	:= 2;
			SET Par_ErrMen 	:= 'El Tipo de Activo no Existe';
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FechaRegistro = Fecha_Vacia ) THEN
			SET Par_NumErr 	:= 3;
			SET Par_ErrMen 	:= 'La fecha de Registro esta Vacia.';
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_Mes  := SUBSTRING(Par_FechaRegistro, 6, 2);
		SET Var_Anio := SUBSTRING(Par_FechaRegistro, 3, 2);

		SELECT	Folio
		INTO 	Var_Folio
		FROM FOLIOSACTIVOS
		WHERE Anio = Var_Anio
		  AND Mes = Var_Mes
		  AND TipoActivoID = Par_TipoActivoID
		LIMIT Entero_Uno;

		SET Var_Folio := IFNULL(Var_Folio, Entero_Cero);

		IF( Var_Folio > Entero_Cero ) THEN

			SET Aud_FechaActual := NOW();
			UPDATE FOLIOSACTIVOS SET
				Folio			= Folio + Entero_Uno,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE Anio = Var_Anio
			  AND Mes = Var_Mes
			  AND TipoActivoID = Par_TipoActivoID;

			SELECT	MAX(Folio)
			INTO 	Var_Folio
			FROM FOLIOSACTIVOS
			WHERE Anio = Var_Anio
			  AND Mes = Var_Mes
			  AND TipoActivoID = Par_TipoActivoID;

			SET Var_Consecutivo := Var_Folio;

		ELSE

			SET Aud_FechaActual := NOW();
			INSERT INTO FOLIOSACTIVOS (
				Anio,			Mes,				TipoActivoID,		Folio,
				EmpresaID,		Usuario,			FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,		NumTransaccion)
			VALUES (
				Var_Anio,		Var_Mes,			Par_TipoActivoID,	Entero_Uno,
				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,	Aud_NumTransaccion);

			SET Var_Consecutivo := Entero_Uno;
		END IF;

		IF( Var_Consecutivo = 10000 ) THEN
			SET Par_NumErr 	:= 4;
			SET Par_ErrMen 	:= CONCAT('El Tipo de Activo: ',Par_TipoActivoID, ' ha alcanzado el número maximo de Folios para el año y mes de Registro.');
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT ClaveTipoActivo
		INTO Var_ClaveTipoActivo
		FROM TIPOSACTIVOS
		WHERE TipoActivoID = Par_TipoActivoID;

		SET Var_ClaveTipoActivo := IFNULL(Var_ClaveTipoActivo, Cadena_Vacia);
		IF( Var_ClaveTipoActivo = Cadena_Vacia ) THEN
			SET Par_NumErr 	:= 5;
			SET Par_ErrMen 	:= 'La clave del Tipo de Activo es vacia.';
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_Consecutivo := CONCAT(Var_ClaveTipoActivo,Var_Anio,Var_Mes,LPAD(CAST(Var_Consecutivo AS CHAR), Con_Validador,'0'));
		SET Par_Consecutivo := IFNULL(Par_Consecutivo, Cadena_Vacia);

		IF( LENGTH(Par_Consecutivo) <> Con_LongitudFolio) THEN
			SET Par_NumErr 	:= 19;
			SET Par_ErrMen 	:= 'El consecutivo asignado al Activo no es valido.';
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= CONCAT('Consecutivo Asignado Exitosamente:', CAST(Par_Consecutivo AS CHAR));
		SET Var_Control		:= 'tipoActivoID';


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$