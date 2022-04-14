-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSANTGASTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSANTGASTOSALT`;DELIMITER $$

CREATE PROCEDURE `TIPOSANTGASTOSALT`(
    inout Par_TipoAntGastoID     int,
    Par_Descripcion    	    	 varchar(75),
    Par_Naturaleza       		 char(1),
    Par_Estatus         		 char(1),
    Par_EsGasto					 char(1),

	Par_ReqNoEmp				 char(1),
    Par_CtaContable    			 char(25),
    Par_CentroCosto		  		 varchar(30),
    Par_Instrumento 			 int(11),
    Par_MontoMaxEfect			 decimal(14,2),

	Par_TipoGastoID 			 int(11),
    Par_MontoMaxTrans			 decimal(14,2),

    Par_Salida          		 char(1),
    INOUT Par_NumErr    		 int,
    INOUT Par_ErrMen    	 	 varchar(400),

    Par_EmpresaID       		 int,
    Aud_Usuario         		 int,
    Aud_FechaActual     		 datetime,
    Aud_DireccionIP     		 varchar(15),
    Aud_ProgramaID      		 varchar(50),
    Aud_Sucursal        		 int,
    Aud_NumTransaccion  		 bigint
    	)
TerminaStore: BEGIN


Declare varControl          	varchar(50);
DECLARE Var_consecutivo			varchar(100);


Declare Entero_Cero     		int;
Declare Decimal_Cero			decimal(14,2);
Declare Cadena_Vacia			char(1);
Declare Fecha_Vacia				date;
Declare Salida_SI           	char(1);
Declare EsGastoTesoreria		char(1);
Declare NumeroTipoGastoAnt		int;

Set varControl          :='';


Set Entero_Cero     			:= 0;
Set Decimal_Cero   				:= 0.0;
Set Cadena_Vacia    			:= '';
Set Fecha_Vacia     			:= '1900-01-01';
Set Salida_SI       			:='S';
Set EsGastoTesoreria			:='S';
set NumeroTipoGastoAnt			:=0;


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-TIPOSANTGASTOSALT');
			SET varControl = 'sqlException' ;
		END;


	set Aud_FechaActual	:=now();

	IF(Par_Descripcion = Cadena_Vacia)THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'La Descripcion se Encuentra Vacia';
			SET varControl  := 'descripcion' ;
			LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_Naturaleza,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := '002';
		SET Par_ErrMen  := 'Especificar Naturaleza.';
		SET varControl  := 'naturaleza1' ;
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_Estatus,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := '003';
		SET Par_ErrMen  := 'Especificar Estatus.';
		SET varControl  := 'estatus' ;
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_EsGasto,Cadena_Vacia))= Cadena_Vacia THEN
		SET Par_NumErr  := '004';
		SET Par_ErrMen  := 'Especificar si es Gasto de Tesoreria.';
		SET varControl  := 'esGasto1' ;
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_ReqNoEmp,Cadena_Vacia))= Cadena_Vacia THEN
		SET Par_NumErr  := '005';
		SET Par_ErrMen  := 'Especifcar si Requiere No. Empleado.';
		SET varControl  := 'reqNoEmp1' ;
		LEAVE ManejoErrores;
	END IF;

	IF (Par_EsGasto=EsGastoTesoreria)THEN
		IF(ifnull(Par_TipoGastoID,Entero_Cero) = Entero_cero) then
				SET Par_NumErr  := '006';
				SET Par_ErrMen  := 'El tipo de Gasto de Tesoreria esta Vacio.';
				SET varControl  := 'tipoGastoID';
				LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(ifnull(Par_CtaContable,Cadena_Vacia))= Cadena_Vacia THEN
		SET Par_NumErr  := '007';
		SET Par_ErrMen  := 'La Cuenta Contable esta Vacia.';
		SET varControl  := 'ctaContable' ;
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_CentroCosto,Cadena_Vacia))= Cadena_Vacia THEN
		SET Par_NumErr  := '008';
		SET Par_ErrMen  := 'El Centro de Costo esta Vacio.';
		SET varControl  := 'centroCosto' ;
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_Instrumento,Entero_Cero))= Entero_cero THEN
		SET Par_NumErr  := '009';
		SET Par_ErrMen  := 'El Instrumento esta Vacio.';
		SET varControl  := 'instrumento' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_MontoMaxEfect > Par_MontoMaxTrans) THEN
		SET Par_NumErr  := '010';
		SET Par_ErrMen  := 'El Monto Maximo de Efectivo no puede ser Mayor al Monto Maximo de Transaccion.';
		SET varControl  := 'montoMaxEfect' ;
		LEAVE ManejoErrores;
	END IF;



	set NumeroTipoGastoAnt := (select ifnull(Max(TipoAntGastoID),Entero_Cero) + 1 from TIPOSANTGASTOS);


	insert into TIPOSANTGASTOS(
				TipoAntGastoID,     Descripcion,        Naturaleza,         Estatus,            EsGastoTeso,
				TipoGastoID,     	ReqNoEmp,       	CtaContable,     	CentroCosto,   	 	Instrumento,
				MontoMaxEfect,      MontoMaxTrans,		EmpresaID,   		Usuario, 			FechaActual,
				DireccionIP,        ProgramaID,         Sucursal,         	NumTransaccion)
		values( NumeroTipoGastoAnt,	Par_Descripcion,	Par_Naturaleza,		Par_Estatus,		Par_EsGasto,
				Par_TipoGastoID,	Par_ReqNoEmp,		Par_CtaContable,	Par_CentroCosto,	Par_Instrumento,
				Par_MontoMaxEfect,	Par_MontoMaxTrans,	Par_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,  	Aud_ProgramaID,     Aud_Sucursal,   	Aud_NumTransaccion);

		SET Par_NumErr  := 0;
        SET Par_ErrMen  := concat('Anticipo/Gasto Agregado Exitosamente: ', NumeroTipoGastoAnt );
        SET varControl  := 'tipoAntGastoID' ;

  END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
			if(Par_NumErr =0)then
				SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen			AS ErrMen,
				varControl			AS control,
				NumeroTipoGastoAnt		AS consecutivo;
			else
				 SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
					Par_ErrMen			AS ErrMen,
					varControl			AS control,
					Cadena_Vacia		AS consecutivo;
			end if;
		end if;

END TerminaStore$$