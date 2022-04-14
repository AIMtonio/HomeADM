-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETCOBCARTERAASIGACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETCOBCARTERAASIGACT`;DELIMITER $$

CREATE PROCEDURE `DETCOBCARTERAASIGACT`(

	Par_FolioAsigID		INT(11),
	Par_CreditoID		BIGINT(12),
	Par_EstatusCredLib	VARCHAR(20),
	Par_DiasAtrasoLib	INT(11),
	Par_SaldoCapitalLib DECIMAL(16,2),

	Par_SaldoInteresLib	DECIMAL(16,2),
    Par_SaldoMorarioLib	DECIMAL(16,2),
    Par_MotivoLib		VARCHAR(100),
    Par_FechaSis		DATE,
    Par_UsuarioLogID	INT(11),

    Par_NumAct       	INT(11),

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



    DECLARE Var_Control			VARCHAR(50);
    DECLARE Var_Consecutivo		VARCHAR(20);
    DECLARE Var_NumCredAsig		VARCHAR(20);
    DECLARE Var_NumCredLib		VARCHAR(20);
	DECLARE Var_EstAsignacion	VARCHAR(1);



    DECLARE Est_Activo		CHAR(1);
    DECLARE Est_BajaAsig	CHAR(1);
    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Entero_Uno		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Salida_SI		CHAR(1);
	DECLARE Est_Inactivo		CHAR(1);
	DECLARE Est_InactivoDes		CHAR(15);
	DECLARE Est_Autorizado		CHAR(1);
	DECLARE Est_AutorizadoDes	CHAR(15);
	DECLARE Est_Pagado			CHAR(1);
	DECLARE Est_PagadoDes		CHAR(15);
	DECLARE Est_Castigado		CHAR(1);
 	DECLARE Est_CastigadoDes	CHAR(15);
	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_VigenteDes		CHAR(15);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Est_VencidoDes		CHAR(15);
    DECLARE Est_credLiberado	CHAR(1);
    DECLARE Act_LiberaCred		INT(11);



    SET Est_Activo			:= 'A';
    SET Est_BajaAsig		:= 'B';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
    SET Cadena_Vacia		:= '';
    SET Salida_SI			:='S';
    SET Est_Inactivo			:= 'I';
	SET Est_InactivoDes			:= 'INACTIVO';
	SET Est_Autorizado			:= 'A';
	SET Est_AutorizadoDes		:= 'AUTORIZADO';
	SET Est_Pagado				:= 'P';
	SET Est_PagadoDes			:= 'PAGADO';
	SET Est_Castigado			:= 'K';
 	SET Est_CastigadoDes		:= 'CASTIGADO';
	SET Est_Vigente				:= 'V';
	SET Est_VigenteDes			:= 'VIGENTE';
	SET Est_Vencido				:= 'B';
	SET Est_VencidoDes			:= 'VENCIDO';
	SET Est_credLiberado		:= 'N';
	SET Act_LiberaCred			:= 1;


	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-DETCOBCARTERAASIGACT');
		SET Var_Control = 'sqlException' ;
	END;


IF (Par_NumAct = Act_LiberaCred)THEN

	SET Var_EstAsignacion := (SELECT EstatusAsig FROM COBCARTERAASIG WHERE FolioAsigID 	= Par_FolioAsigID );

	IF(Var_EstAsignacion = Est_BajaAsig)THEN
		SET Par_NumErr = 1;
		SET Par_ErrMen = 'La Asignacion ya esta Liberada';
        SET Var_Consecutivo = Par_FolioAsigID;
		SET Var_Control = 'asignadoID' ;
		LEAVE ManejoErrores;
    END IF;

    SET Aud_FechaActual = now();
    SET Par_EstatusCredLib := CASE	WHEN Par_EstatusCredLib=Est_InactivoDes	THEN Est_Inactivo
									WHEN Par_EstatusCredLib=Est_AutorizadoDes THEN	Est_Autorizado
									WHEN Par_EstatusCredLib=Est_PagadoDes	THEN Est_Pagado
									WHEN Par_EstatusCredLib=Est_VencidoDes	THEN Est_Vencido
									WHEN Par_EstatusCredLib=Est_VigenteDes	THEN Est_Vigente
									WHEN Par_EstatusCredLib=Est_CastigadoDes THEN Est_Castigado END;

	UPDATE DETCOBCARTERAASIG
		SET
			EstatusCredLib		=	Par_EstatusCredLib,
			DiasAtrasoLib		=	Par_DiasAtrasoLib,
            SaldoCapitalLib		=	Par_SaldoCapitalLib,
            SaldoInteresLib		=	Par_SaldoInteresLib,
            SaldoMoratorioLib	=	Par_SaldoMorarioLib,

            MotivoLiberacion	=	Par_MotivoLib,
            CredAsignado	=	Est_credLiberado,
            FechaLibCred	= 	Par_FechaSis,
            UsuarioLibCred	= 	Par_UsuarioLogID,

            EmpresaID		= Par_EmpresaID,
            Usuario         = Aud_Usuario,
            FechaActual 	= Aud_FechaActual,
            DireccionIP 	= Aud_DireccionIP,
            ProgramaID  	= Aud_ProgramaID,
            Sucursal		= Aud_Sucursal,
            NumTransaccion	= Aud_NumTransaccion
		WHERE FolioAsigID = Par_FolioAsigID
			AND CreditoID = Par_CreditoID;

	SET Var_NumCredAsig :=(SELECT COUNT(FolioAsigID) FROM DETCOBCARTERAASIG WHERE FolioAsigID = Par_FolioAsigID);
    SET Var_NumCredLib :=(SELECT COUNT(FolioAsigID) FROM DETCOBCARTERAASIG WHERE FolioAsigID = Par_FolioAsigID AND CredAsignado = Est_credLiberado);


    IF(Var_NumCredAsig = Var_NumCredLib)THEN
		UPDATE COBCARTERAASIG
			SET EstatusAsig  	= Est_BajaAsig,
				FechaBaja		= Par_FechaSis,
				UsuarioLibeID	= Par_UsuarioLogID,

				EmpresaID		= Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE FolioAsigID 	= Par_FolioAsigID;

    END IF;

    SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= CONCAT('Liberacion de Cartera Realizada Exitosamente: ', CAST(Par_FolioAsigID AS CHAR) );
	SET Var_Control	:= 'asignadoID';
	SET Var_Consecutivo:= Par_FolioAsigID;

END IF;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$