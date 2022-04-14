-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEARCHIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTEARCHIVOSALT`;
DELIMITER $$

CREATE PROCEDURE `CLIENTEARCHIVOSALT`(
/*SP para dar del Alta los Archivos del Cliente/Prospect*/
	Par_ClienteID			INT(11),
	Par_ProspectoID			BIGINT(20),
	Par_TipoDocumen			INT,
	Par_Observacion			VARCHAR(200),
	Par_Recurso				VARCHAR(500),
	Par_Extension			VARCHAR(50),
	Par_Instrumento			INT(11),
	Par_FechaRegistro		DATE,

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE noConsecutivo		INT;
	DECLARE Var_Consecutivo 	VARCHAR(200);				# Numero consecutivo para la imagen a digitalizar
	DECLARE Var_Control			VARCHAR(50);				# ID del Control en pantalla
	DECLARE Var_Fechasistema	DATE;
	DECLARE varCliArchivosID	INT;
	DECLARE varCliente			INT;
	DECLARE varDesTipDoc		VARCHAR(60);
	DECLARE varProspectoID		BIGINT(20);
	DECLARE varRecurso			VARCHAR(500);
	DECLARE varTipoDocID		INT;
	DECLARE Var_FechaRegistro	DATE;
	DECLARE Var_NumMeses		INT;
	DECLARE Var_FechaExpira		DATE;
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	Estatus_Activo		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	SalidaSI			CHAR(1);

	-- Declaracion de extenciones
	DECLARE Ext_PDF				VARCHAR(4);
	DECLARE Ext_JPG				VARCHAR(4);
	DECLARE Ext_JPEG			VARCHAR(5);
	DECLARE Ext_GIF				VARCHAR(4);
	DECLARE Ext_PNG				VARCHAR(4);
	DECLARE Ext_BMP				VARCHAR(4);
	DECLARE Ext_TIFF			VARCHAR(5);

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:= 0;
	SET Estatus_Activo			:= 'A';
	SET Fecha_Vacia				:= '1900-01-01';
	SET noConsecutivo			:= 0;
	SET SalidaSI				:= 'S';

	SET Ext_PDF				:=	'.pdf';
	SET Ext_JPG				:=	'.jpg';
	SET Ext_JPEG			:=	'.jpeg';
	SET Ext_GIF				:=	'.gif';
	SET Ext_PNG				:=	'.png';
	SET Ext_BMP				:=	'.bmp';
	SET Ext_TIFF			:=	'.tiff';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIENTEARCHIVOSALT');
			SET Var_Control		:= 'sqlException' ;
		END;
		SELECT
			FechaSistema, FecVigenDomicilio
			INTO Var_Fechasistema, Var_NumMeses
			FROM PARAMETROSSIS LIMIT 1;



		IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
			SET varProspectoID := (SELECT Pro.ProspectoID
							FROM PROSPECTOS Pro
							WHERE Pro.ProspectoID = Par_ProspectoID);
			IF(IFNULL(varProspectoID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr	:= '003';
				SET Par_ErrMen	:= 'El Prospecto no Existe.' ;
				SET Var_Control	:= 'prospectoID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		  ELSE
			SET varCliente := (SELECT Cli.ClienteID
								FROM CLIENTES Cli
								WHERE Cli.ClienteID = Par_ClienteID);
			IF(IFNULL(varCliente, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := '001';
				SET Par_ErrMen := 'El Numero de Cliente no existe.' ;
				SET Var_Control	:= 'clienteID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

			SET varTipoDocID := (SELECT Tic.TipoDocumentoID
						FROM TIPOSDOCUMENTOS Tic
							WHERE Tic.TipoDocumentoID = Par_TipoDocumen);

			IF(IFNULL(varTipoDocID, Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr := '002';
					SET Par_ErrMen := 'El Tipo de documento no Existe.' ;
					SET Var_Control	:= 'tipoDocumentoID';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
			END IF;

			IF IFNULL(Par_Extension,Cadena_Vacia) = Cadena_Vacia THEN
					SET Par_NumErr := '003';
					SET Par_ErrMen := 'La extención del archivo esta vacia.' ;
					SET Var_Control	:= 'tipoDocumentoID';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
			ELSE
				IF (LOWER(Par_Extension) != Ext_PDF 	AND LOWER(Par_Extension) != Ext_JPG AND
					LOWER(Par_Extension) != Ext_JPEG 	AND LOWER(Par_Extension) != Ext_GIF AND
					LOWER(Par_Extension) != Ext_PNG 	AND LOWER(Par_Extension) != Ext_BMP AND
					LOWER(Par_Extension) != Ext_TIFF) THEN
						SET Par_NumErr := '004';
						SET Par_ErrMen := 'La extención del archivo no es valida.' ;
						SET Var_Control	:= 'tipoDocumentoID';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;	
				END IF;
			END IF; 


			IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
				-- si el cliente es nulo entonces se trata de un prospecto
				-- Se obtiene el consecutivo por cliente y por tipo de documento
				SET	noConsecutivo	:=(SELECT MAX(Consecutivo)
									   FROM CLIENTEARCHIVOS
									   WHERE ProspectoID = Par_ProspectoID AND TipoDocumento = Par_TipoDocumen);
				SET noConsecutivo:=IFNULL(noConsecutivo,Entero_Cero)+1;
			  ELSE
				SET	noConsecutivo	:=(SELECT MAX(Consecutivo)
									   FROM CLIENTEARCHIVOS
									   WHERE ClienteID = Par_ClienteID AND TipoDocumento = Par_TipoDocumen);
				SET noConsecutivo	:=IFNULL(noConsecutivo,Entero_Cero)+1;
			END IF;

			SET varDesTipDoc :=  (SELECT Descripcion FROM TIPOSDOCUMENTOS WHERE TipoDocumentoID = Par_TipoDocumen);

			-- Consecutivo General
			CALL FOLIOSAPLICAACT('CLIENTEARCHIVOS', varCliArchivosID);

			SET Aud_FechaActual := CURRENT_TIMESTAMP();

			SET Var_Fechasistema:= IFNULL(Var_Fechasistema,Fecha_Vacia);
			SET Par_Extension :=IFNULL(Par_Extension,Cadena_Vacia);
			SET varRecurso := CONCAT(Par_Recurso,varDesTipDoc,"/Archivo", RIGHT(CONCAT("00000",CONVERT(noConsecutivo, CHAR)), 5),Par_Extension );
			IF(Par_FechaRegistro != Fecha_Vacia) THEN
				SET Var_FechaRegistro		:= Par_FechaRegistro;
			ELSE
				SET Var_FechaRegistro		:= Var_Fechasistema;
			END IF;

			SET Var_FechaExpira	:= FNSUMMESESFECHA(Var_FechaRegistro,IFNULL(Var_NumMeses,Entero_Cero));

			INSERT INTO CLIENTEARCHIVOS(
				ClienteArchivosID,		ClienteID,		ProspectoID,		TipoDocumento,	Consecutivo,
				Observacion,			Recurso,		Instrumento,		FechaRegistro,	FechaExpira,
				EmpresaID,				Usuario,		FechaActual,		DireccionIP,	ProgramaID,
				Sucursal,				NumTransaccion)
			VALUES  (
				varCliArchivosID,		Par_ClienteID,		Par_ProspectoID, 	Par_TipoDocumen,    noConsecutivo,
				Par_Observacion,		varRecurso,			Par_Instrumento,	Var_FechaRegistro,	Var_FechaExpira,
				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('El archivo se ha Digitalizado Exitosamente.');
		SET Var_Control 	:= 'clienteID' ;
		SET Var_Consecutivo	:= noConsecutivo;
	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo,
		varRecurso	AS recurso;
	END IF;
END TerminaStore$$