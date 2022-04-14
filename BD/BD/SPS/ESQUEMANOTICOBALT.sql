-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMANOTICOBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMANOTICOBALT`;DELIMITER $$

CREATE PROCEDURE `ESQUEMANOTICOBALT`(

    Par_EsquemaID		INT(11),
    Par_DiasAtrasoIni 	INT(11),
    Par_DiasAtrasoFin 	INT(11),
    Par_NumEtapa		INT(11),
    Par_EtiquetaEtapa	VARCHAR(10),

	Par_Accion			VARCHAR(200),
    Par_FormatoID		INT(11),

    Par_Salida			CHAR(1),
    inout Par_NumErr	INT(11),
    inout Par_ErrMen	VARCHAR(150),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

)
TerminaStore: BEGIN


    DECLARE Var_Control		VARCHAR(50);
    DECLARE Var_Consecutivo	VARCHAR(20);


    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Entero_Uno		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Salida_SI		CHAR(1);


	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
    SET Cadena_Vacia		:= '';
    SET Salida_SI			:= 'S';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ESQUEMANOTICOBALT');
		SET Var_Control = 'sqlException' ;
	END;

		IF(IFNULL(Par_DiasAtrasoFin, Entero_Cero) < IFNULL(Par_DiasAtrasoIni, Entero_Cero) )THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El numero de Dias de Atraso Final deben ser Mayor o Igual a el numero Dias de Atraso de Inicial';
			SET Var_Control	:= CONCAT('diasArasoFin',Par_EsquemaID);
			LEAVE ManejoErrores;
		END IF;

        IF EXISTS (SELECT EsquemaID FROM ESQUEMANOTICOB WHERE Par_DiasAtrasoIni BETWEEN DiasAtrasoIni and DiasAtrasoFin) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Numero de Dias de Atraso de Inicio ya esta parametrizado';
			SET Var_Control	:= CONCAT('diasArasoIni',Par_EsquemaID);
			LEAVE ManejoErrores;
		END IF;

        IF EXISTS (SELECT EsquemaID FROM ESQUEMANOTICOB WHERE Par_DiasAtrasoFin BETWEEN DiasAtrasoIni and DiasAtrasoFin) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El Numero de Dias de Atraso Final ya esta parametrizado';
			SET Var_Control	:= CONCAT('diasArasoFin',Par_EsquemaID);
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DiasAtrasoFin, Entero_Cero) <= Entero_Cero )THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El Numero de Dias de Atraso Final debe ser mayor a 0';
			SET Var_Control	:= CONCAT('numEtapa',Par_EsquemaID);
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumEtapa, Entero_Cero) = Entero_Cero )THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'El Numero de Etapa debe ser mayor a cero';
			SET Var_Control	:= CONCAT('numEtapa',Par_EsquemaID);
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EtiquetaEtapa, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'La Etiqueta de La Etapa esta vacia';
			SET Var_Control	:= CONCAT('etiquetaEtapa',Par_EtiquetaEtapa);
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Accion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 7;
			SET Par_ErrMen := 'La Accion esta vacia';
			SET Var_Control	:= CONCAT('accion',Par_EsquemaID);
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FormatoID, Entero_Cero) = Entero_Cero )THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := 'El Formato de notificacion esta vacio';
			SET Var_Control	:= CONCAT('formatoNoti',Par_EsquemaID);
			LEAVE ManejoErrores;
		END IF;

        SET Aud_FechaActual = now();

        INSERT INTO ESQUEMANOTICOB
		(	`EsquemaID`, 		`DiasAtrasoIni`, 	`DiasAtrasoFin`,	`NumEtapa`, 		`EtiquetaEtapa`,
			`Accion`, 			`FormatoID`, 		`EmpresaID`, 		`Usuario`, 			`FechaActual`,
            `DireccionIP`, 		`ProgramaID`, 		`Sucursal`, 		`NumTransaccion`
		)VALUES(
			Par_EsquemaID,		Par_DiasAtrasoIni,	Par_DiasAtrasoFin,	Par_NumEtapa,		Par_EtiquetaEtapa,
            Par_Accion,			Par_FormatoID,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		);

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Esquema de Notificacion Grabado Exitosamente: ', CAST(Par_EsquemaID AS CHAR) );
		SET Var_Control	:= 'diasAtrasoIni1';
		SET Var_Consecutivo:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;


END TerminaStore$$