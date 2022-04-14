-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBCARTERAASIGALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBCARTERAASIGALT`;DELIMITER $$

CREATE PROCEDURE `COBCARTERAASIGALT`(

	Par_FechaAsig			DATE,
	Par_GestorID			INT(11),
	Par_PorcentajeComision	DECIMAL(12,2),
	Par_TipoAsigCobranzaID	INT(11),
	Par_UsuarioAsigID		INT(11),

	Par_DiaAtrasoMin		INT(11),
    Par_DiaAtrasoMax		INT(11),
    Par_AdeudoMin			DECIMAL(12,2),
    Par_AdeudoMax			DECIMAL(12,2),
    Par_EstCredito			VARCHAR(10),

    Par_SucursalID			INT(11),
    Par_EstadoID			INT(11),
	Par_MunicipioID			INT(11),
	Par_LocalidadID			INT(11),
	Par_ColoniaID			INT(11),

    Par_LimRenglones		INT(11),

    Par_Salida				CHAR(1),
    inout Par_NumErr		INT(11),
    inout Par_ErrMen		VARCHAR(150),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN



    DECLARE Var_FolioAsigID	INT(11);
    DECLARE Var_Control		VARCHAR(50);
    DECLARE Var_Consecutivo	VARCHAR(20);



    DECLARE Est_Activo		CHAR(1);
    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Salida_SI		CHAR(1);
    DECLARE Cadena_Vacia	CHAR(1);



    SET Est_Activo			:= 'A';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
    SET Salida_SI			:='S';
    SET Cadena_Vacia		:='';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-COBCARTERAASIGALT');
		SET Var_Control = 'sqlException' ;
	END;

    CALL FOLIOSAPLICAACT('COBCARTERAASIG', Var_FolioAsigID);
       SET Aud_FechaActual = now();

	INSERT INTO `COBCARTERAASIG`(
		`FolioAsigID`,			`FechaAsig`,			`GestorID`,				`PorcentajeComision`,	  	`TipoAsigCobranzaID`,
		`EstatusAsig`,			`FechaBaja`,			`UsuarioAsigID`,		`UsuarioLibeID`,			`DiaAtrasoMin`,
		`DiaAtrasoMax`, 		`AdeudoMin`, 			`AdeudoMax`, 			`EstCredito`, 				`SucursalID`,
        `EstadoID`, 			`MunicipioID`, 			`LocalidadID`, 			`ColoniaID`, 				`LimRenglones`,
        `EmpresaID`, 			`Usuario`,				`FechaActual`,			`DireccionIP`, 				`ProgramaID`,
        `Sucursal`, 			`NumTransaccion`)
	VALUES(
		Var_FolioAsigID,		Par_FechaAsig,			Par_GestorID,			Par_PorcentajeComision,		Par_TipoAsigCobranzaID,
		Est_Activo,				Fecha_Vacia,			Par_UsuarioAsigID,		Entero_Cero,				Par_DiaAtrasoMin,
        Par_DiaAtrasoMax,		Par_AdeudoMin,			Par_AdeudoMax,			IFNULL(Par_EstCredito,Cadena_Vacia),				Par_SucursalID,
		Par_EstadoID,			Par_MunicipioID,		Par_LocalidadID,		Par_ColoniaID,				Par_LimRenglones,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
        Aud_Sucursal,			Aud_NumTransaccion
        );

    SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= CONCAT('Asignacion de Cartera Agregada Exitosamente: ', CAST(Var_FolioAsigID AS CHAR) );
	SET Var_Control	:= 'asignadoID';
	SET Var_Consecutivo:= Var_FolioAsigID;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$