-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRMAREPLEGALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FIRMAREPLEGALALT`;DELIMITER $$

CREATE PROCEDURE `FIRMAREPLEGALALT`(
	Par_RepresentLegal		VARCHAR(70),		-- Nombre Representante Legal
	Par_Recurso				VARCHAR(100),		-- Ruta Archivo

	Par_Observacion			VARCHAR(100),		-- Observacion
	Par_Extension			CHAR(5),			-- Estenxion Archivo
	Par_Salida				CHAR(1),			-- Indica Salida
	INOUT Par_NumErr		INT,				-- INOUT Num_Err
	INOUT Par_ErrMen		VARCHAR(400),		-- INOUT ErrMen

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_Fechasistema 	DATE;
	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_FirmaID			INT(11);
	DECLARE Var_Recurso			CHAR(100);
	DECLARE Var_Control			VARCHAR(100);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	SalidaSI			CHAR(1);

	-- asignacion de constantes
	SET Cadena_Vacia    := '';
	SET Fecha_Vacia     := '1900-01-01';
	SET Entero_Cero     :=  0;
	SET SalidaSI        := 'S';

	--  Asignacion de Variables
	SET Var_Consecutivo	:= 0;
	SET Var_FirmaID		:= 0;

    ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-FIRMAREPLEGALALT');
			SET Var_Control = 'SQLEXCEPTION' ;
		END;


		SET Par_RepresentLegal := IFNULL(Par_RepresentLegal,Cadena_Vacia);
		IF(Par_RepresentLegal = Cadena_Vacia) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'El Representante Legal Viene Vacio.';
				SET Var_Control	:= 'representLegal';
				LEAVE ManejoErrores;
		END IF;

		-- Se obtiene el consecutivo de la firma del representante
		SET	Var_Consecutivo	:=(SELECT IFNULL(MAX(Consecutivo),Entero_Cero)+1
							   FROM FIRMAREPLEGAL
							   WHERE RepresentLegal = Par_RepresentLegal);
		-- Consecutivo General
		CALL FOLIOSAPLICAACT('FIRMAREPLEGAL', Var_FirmaID);

		SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();
		SET Var_Fechasistema	:=IFNULL((SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1),Fecha_Vacia);

		SET Var_Recurso 	:= CONCAT(Par_Recurso,"/Archivo", RIGHT(CONCAT("00000",CONVERT(Var_Consecutivo, CHAR)), 5),Par_Extension );

		INSERT INTO FIRMAREPLEGAL(
			FirmaID,			RepresentLegal,			Consecutivo,		Observacion,		Recurso,
			FechaRegistro,		EmpresaID,				Usuario,			FechaActual,		DireccionIP,
			ProgramaID,			Sucursal,				NumTransaccion
		)VALUES(
			Var_FirmaID,		Par_RepresentLegal,		Var_Consecutivo, 	Par_Observacion,	Var_Recurso,
			Var_Fechasistema,	Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'El Archivo se ha Digitalizado Exitosamente';
		SET Var_Control	:= 'representLegal';

	END ManejoErrores;

		IF(Par_Salida = SalidaSI) THEN
			SELECT 	Par_NumErr AS NumErr,
					Par_ErrMen  AS ErrMen,
					Var_Control AS control,
				    CONVERT(Var_Consecutivo, CHAR) AS consecutivo,
				   Var_Recurso AS recurso;
		END IF;

END TerminaStore$$