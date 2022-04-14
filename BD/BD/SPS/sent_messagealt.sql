-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- sent_messagealt
DELIMITER ;
DROP PROCEDURE IF EXISTS `sent_messagealt`;DELIMITER $$

CREATE PROCEDURE `sent_messagealt`(
    Par_Receiver        varchar(45),
    Par_Message         varchar(150),


    Par_Salida 				char(1),
	inout	Par_NumErr	 	int,
	inout	Par_ErrMen	 	varchar(100),


    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE	NoCel_Envio		varchar(45);



DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		varchar(20);
DECLARE	Entero_Cero		int;
DECLARE	Salida_SI 		char(1);
DECLARE	Sin_Enviar      char(2);


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Salida_SI       := 'S';
Set Sin_Enviar      := '00';

select  SmsID into NoCel_Envio
    from PARAMETROSSIS;


insert into sent_message (status, receiver, sender, sent, message) values
(   Sin_Enviar, Par_Receiver, NoCel_Envio, Fecha_Vacia,
    Par_Message);

END TerminaStore$$