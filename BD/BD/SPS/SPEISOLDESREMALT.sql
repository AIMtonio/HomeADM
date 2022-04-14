-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEISOLDESREMALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEISOLDESREMALT`;
DELIMITER $$

CREATE PROCEDURE `SPEISOLDESREMALT`(
-- =====================================================================================
-- ------- STORED PARA ALTA DE SOLICITUD DE DESCARGA DE REMESA ---------
-- =====================================================================================
    INOUT Par_SpeiSolDesID  BIGINT(20),
	Par_FechaRegistro       DATETIME,
    Par_Estatus             CHAR(1),
	Par_FechaProceso        DATETIME,

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID		    INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(20),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)

TerminaStore: BEGIN

	DECLARE Var_Control        VARCHAR(200);


	DECLARE	 Cadena_Vacia		CHAR(1);
	DECLARE	 Fecha_Vacia		DATE;
	DECLARE	 Hora_Vacia 		TIME;
	DECLARE	 Entero_Cero		INT;
	DECLARE	 Decimal_Cero		DECIMAL(12,2);
	DECLARE  Par_NumErr      	INT;
	DECLARE  Par_ErrMen      	VARCHAR(400);
	DECLARE  SalidaNO        	CHAR(1);
	DECLARE  SalidaSI        	CHAR(1);
	DECLARE  Estatus_Pen        CHAR(1);


	SET	Cadena_Vacia		    := '';
	SET	Fecha_Vacia			    := '1900-01-01';
	SET	Hora_Vacia			    := '00:00:00';
	SET	Entero_Cero			    := 0;
	SET	Decimal_Cero		    := 0.0;
	SET SalidaSI        	    := 'S';
	SET SalidaNO        	    := 'N';
	SET Par_NumErr  		    := 0;
	SET Par_ErrMen  		    := '';
	SET Estatus_Pen             := 'P';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-SPEISOLDESREMALT');
			SET Var_Control = 'sqlException' ;
		END;

		IF(IFNULL(Par_FechaRegistro,Fecha_Vacia))= Fecha_Vacia THEN
			SET Par_NumErr  := 001 ;
			SET Par_ErrMen  := 'La fecha de registro esta vacia.';
			SET Var_Control := 'fechaRegistro' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Estatus,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El estatus de la solicitud esta vacia.';
			SET Var_Control := 'estatus' ;
			LEAVE ManejoErrores;
		END IF;

		SET Par_SpeiSolDesID:= (SELECT IFNULL(MAX(SpeiSolDesID),Entero_Cero) + 1 FROM SPEISOLDESREM);

		INSERT INTO SPEISOLDESREM(
			SpeiSolDesID,	    FechaRegistro,		Estatus,		    FechaProceso,      EmpresaID,
			Usuario,	 	    FechaActual,		DireccionIP,		ProgramaID,		   Sucursal,
			NumTransaccion
		)VALUES(
			Par_SpeiSolDesID,	Par_FechaRegistro,	Par_Estatus,		Par_FechaProceso,  Par_EmpresaID,
			Aud_Usuario,    	Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,	   Aud_Sucursal,
			Aud_NumTransaccion
		);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Solicitud Agregada exitosamente.';
		SET Var_Control := 'speiSolDesID' ;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		 AS ErrMen,
				Var_Control		 AS control,
				Par_SpeiSolDesID AS consecutivo;
	END IF;

END TerminaStore$$