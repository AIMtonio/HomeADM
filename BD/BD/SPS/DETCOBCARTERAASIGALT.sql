-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETCOBCARTERAASIGALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETCOBCARTERAASIGALT`;DELIMITER $$

CREATE PROCEDURE `DETCOBCARTERAASIGALT`(
	/* 	SP PARA EL REGISTRO DE LOS DETALLES DE LOS CREDITOS ASIGNADOS A COBRANZA	*/
	Par_FolioAsigID		INT(11),			-- ID de la tabla COBCARTERAASIG
	Par_CreditoID		BIGINT(12),			-- ID del Credito asignado
	Par_ClienteID		INT(11),			-- ID del Cliente
	Par_EstatusCred		VARCHAR(20),		-- Estatus Credito I = Inactivo A= Autorizado V= Vigente P = Pagado C = Cancelado B= Vencido K= Castigado
	Par_DiasAtraso		INT(11),			-- Dias de atraso que tiene el Credito

    Par_MontoCredito	DECIMAL(12,2), 		-- Monto otorgado del credito
	Par_FechaDesembolso	DATE,				-- Fecha de desembolso
	Par_FechaVencimien	DATE,				-- Fecha de vencimiento
	Par_SaldoCapital	DECIMAL(16,2), 		-- Saldo capital al dia de la asignacion
	Par_SaldoInteres	DECIMAL(16,2), 		-- Saldo intereses al dia de la asignacion

    Par_SaldoMoratorio	DECIMAL(16,2), 		-- Saldo moratorios al dia de la asignacion
    Par_SucursalID		INT(11),			-- Sucursal de origen del credito
    Par_NombreCompleto	VARCHAR(200),		-- Nombre comleto del cliente

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

	-- Declaracion de variables

    DECLARE Var_Control			VARCHAR(50);		-- Variable de control
    DECLARE Var_Consecutivo		VARCHAR(20);
    DECLARE Var_NumAsig			INT(11);

    -- Declaracion de constantes

    DECLARE Est_Activo		CHAR(1);
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
    DECLARE Est_credAsignado	CHAR(1);

    -- Asignacion de constantes

    SET Est_Activo			:= 'A';
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
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
	SET Est_credAsignado		:= 'S';


	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-DETCOBCARTERAASIGALT');
		SET Var_Control = 'sqlException' ;
	END;

    SET Aud_FechaActual = now();
    SET Var_NumAsig := Entero_Uno;
    SET Par_EstatusCred := CASE	WHEN Par_EstatusCred=Est_InactivoDes	THEN Est_Inactivo
								WHEN Par_EstatusCred=Est_AutorizadoDes THEN	Est_Autorizado
								WHEN Par_EstatusCred=Est_PagadoDes	THEN Est_Pagado
								WHEN Par_EstatusCred=Est_VencidoDes	THEN Est_Vencido
								WHEN Par_EstatusCred=Est_VigenteDes	THEN Est_Vigente
								WHEN Par_EstatusCred=Est_CastigadoDes THEN Est_Castigado END;

	SET Var_NumAsig = (SELECT COUNT(IFNULL(CreditoID,Entero_Cero)) FROM DETCOBCARTERAASIG WHERE CreditoID = Par_CreditoID);
    SET Var_NumAsig = IFNULL(Var_NumAsig,Entero_Cero) + Entero_Uno;


	INSERT INTO `DETCOBCARTERAASIG`(
		`FolioAsigID`,			`CreditoID`,			`ClienteID`,			`EstatusCred`,		`DiasAtraso`,
        `MontoCredito`,			`FechaDesembolso`,		`FechaVencimien`,		`SaldoCapital`,		`SaldoInteres`,
        `SaldoMoratorio`,		`EstatusCredLib`,		`DiasAtrasoLib`,		`SaldoCapitalLib`,	`SaldoInteresLib`,
        `SaldoMoratorioLib`,    `MotivoLiberacion`,		`CredAsignado`,			`NumAsig`,			`SucursalID`,
        `NombreCompleto`,
        `EmpresaID`, 			`Usuario`,				`FechaActual`,			`DireccionIP`, 		`ProgramaID`,
        `Sucursal`, 			`NumTransaccion`)


	VALUES(
		Par_FolioAsigID,		Par_CreditoID,			Par_ClienteID,			Par_EstatusCred,	Par_DiasAtraso,
        Par_MontoCredito,		Par_FechaDesembolso,	Par_FechaVencimien,		Par_SaldoCapital,	Par_SaldoInteres,
        Par_SaldoMoratorio,		Cadena_Vacia,			Entero_Cero,			Entero_Cero,		Entero_Cero,
        Entero_Cero,	        Cadena_Vacia,			Est_credAsignado,		Var_NumAsig,		Par_SucursalID,
        Par_NombreCompleto,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
        Aud_Sucursal,			Aud_NumTransaccion
        );

    SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= CONCAT('Asignacion de Cartera Agregada Exitosamente: ', CAST(Par_FolioAsigID AS CHAR) );
	SET Var_Control	:= 'asignadoID';
	SET Var_Consecutivo:= Par_FolioAsigID;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$