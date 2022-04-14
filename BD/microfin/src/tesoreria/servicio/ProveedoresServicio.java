package tesoreria.servicio;

import java.util.ArrayList;
import java.util.List;

import cuentas.bean.TiposCuentaBean;
import cuentas.servicio.TiposCuentaServicio.Enum_Lis_TiposCuenta;
import tesoreria.bean.ProveedoresBean;
import tesoreria.dao.ProveedoresDAO;

 
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ProveedoresServicio extends BaseServicio{

	private ProveedoresServicio(){
		super();
	}

	ProveedoresDAO proveedoresDAO = null;

	public static interface Enum_Lis_Proveedores{
		int alfanumerica = 1;
		int sucursales =2;
		int tipoProveedor = 3;
		int tipoTercero = 4;
		int tipoOperacion = 5;
	}


	public static interface Enum_Tra_Proveedores {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
		int altaProvGasto=4;
		int bajaDef=1;// baja definitiva

	}

	public static interface Enum_Con_Proveedores{
		int principal = 1;
		int cuentaClabe = 3;
		int tipoTercero = 4;
		int tipoOperacion = 5;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ProveedoresBean proveedores){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_Proveedores.alta:
			mensaje = alta(proveedores);
			break;
		case Enum_Tra_Proveedores.modificacion:
			mensaje = modificacion(proveedores);
			break;
		case Enum_Tra_Proveedores.baja:
			mensaje = baja(proveedores);
			break;
		case Enum_Tra_Proveedores.altaProvGasto:
			mensaje = ProveedoresAGastos(proveedores);
			break;
		}
		return mensaje;

	}
	public MensajeTransaccionBean alta(ProveedoresBean proveedores){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		int  tipoProv = 0;
		try{
			
			tipoProv =(proveedores.getTipoProveedorID()!=null || proveedores.getTipoProveedorID()!="")?
						Integer.parseInt(proveedores.getTipoProveedorID()):
					0;
		}catch (NumberFormatException e){
			mensaje.setNumero(1);
			mensaje.setDescripcion("Especifique un tipo de proveedor valido");
			mensaje.setNombreControl("tipoProveedorID");
			mensaje.setConsecutivoString("");
			mensaje.setConsecutivoInt("");
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de proveedores", e);
		}
		if(tipoProv>0){
			mensaje = proveedoresDAO.alta(proveedores);		
		}
		
		return mensaje;
	}

	public MensajeTransaccionBean ProveedoresAGastos(ProveedoresBean proveedores){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaDetalleGrid=null;
		ArrayList listaAnteriores=null;
		
		listaDetalleGrid = (ArrayList) DetalleGrid(proveedores);
		listaAnteriores  = (ArrayList)proveedoresDAO.listaProvPorSucur(proveedores,Enum_Lis_Proveedores.sucursales );	

		ProveedoresBean proveedoresBean=null;
		ProveedoresBean proveedoresBeanAnt=null;
		boolean existe;
		if(listaAnteriores!=null){
			for(int i=0; i< listaAnteriores.size(); i++){
				proveedoresBeanAnt = (ProveedoresBean)listaAnteriores.get(i);
				existe=false;
				if(listaDetalleGrid!=null){
					for(int j=0; j< listaDetalleGrid.size(); j++){
						proveedoresBean = (ProveedoresBean)listaDetalleGrid.get(j);

						if(proveedoresBeanAnt.getSucursal().equals(proveedoresBean.getSucursal())){

							existe=true;
							j=listaDetalleGrid.size();
						}
					}
				}
				if(!existe){
					mensaje = proveedoresDAO.bajaProvTipoGasto(proveedoresBeanAnt,Enum_Tra_Proveedores.bajaDef);
				}


			}
		}
		if(listaDetalleGrid!=null){
			for(int i=0; i< listaDetalleGrid.size(); i++){
				proveedoresBean = (ProveedoresBean)listaDetalleGrid.get(i);
				existe=false;
				if(listaAnteriores!=null){
					for(int j=0; j< listaAnteriores.size(); j++){
						proveedoresBeanAnt = (ProveedoresBean)listaAnteriores.get(j);
						if(proveedoresBean.getSucursal().equals(proveedoresBeanAnt.getSucursal())){
							existe=true;
							j=listaAnteriores.size();
						}
					}
				}
				if(!existe){
					mensaje = proveedoresDAO.altaProvTipoGasto(proveedoresBean);
				}


			}
		}
		return mensaje;
	}


	public MensajeTransaccionBean modificacion(ProveedoresBean proveedores){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		int  tipoProv = 0;
		try{
			
			tipoProv =(proveedores.getTipoProveedorID()!=null || proveedores.getTipoProveedorID()!="")?
						Integer.parseInt(proveedores.getTipoProveedorID()):
					0;
		}catch (NumberFormatException e){
			mensaje.setNumero(1);
			mensaje.setDescripcion("Especifique un tipo de proveedor valido");
			mensaje.setNombreControl("tipoProveedorID");
			mensaje.setConsecutivoString("");
			mensaje.setConsecutivoInt("");
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de proveedores", e);
		}
		if(tipoProv>0){
			try{
				
				tipoProv =(proveedores.getTipoProveedorID()!=null || proveedores.getTipoProveedorID()!="")?
							Integer.parseInt(proveedores.getTipoProveedorID()):
						0;
			}catch (NumberFormatException e){
				mensaje.setNumero(1);
				mensaje.setDescripcion("Especifique un tipo de proveedor valido");
				mensaje.setNombreControl("tipoProveedorID");
				mensaje.setConsecutivoString("");
				mensaje.setConsecutivoInt("");
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de proveedores", e);
			}
			mensaje = proveedoresDAO.modifica(proveedores);
		}
		return mensaje;
	}	

	public MensajeTransaccionBean baja(ProveedoresBean proveedores){
		MensajeTransaccionBean mensaje = null;
		mensaje = proveedoresDAO.baja(proveedores);		
		return mensaje;
	}

	public ProveedoresBean consulta(int tipoConsulta, ProveedoresBean proveedores){
		ProveedoresBean proveedoresBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Proveedores.principal:		
				proveedoresBean = proveedoresDAO.consultaPrincipal(proveedores, tipoConsulta);				
				break;				

			case Enum_Con_Proveedores.cuentaClabe:		
				proveedoresBean = proveedoresDAO.consultaClabeBancaria(proveedores, tipoConsulta);				
				break;	
			case Enum_Con_Proveedores.tipoTercero:		
				proveedoresBean = proveedoresDAO.consultaTipoTercero(proveedores, tipoConsulta);				
				break;	
			case Enum_Con_Proveedores.tipoOperacion:		
				proveedoresBean = proveedoresDAO.consultaTipoOperacion(proveedores, tipoConsulta);				
				break;	

		}
		if(proveedoresBean!=null){
			proveedoresBean.setProveedorID(proveedoresBean.getProveedorID());
		}
		return proveedoresBean;
	}


	public List lista(int tipoLista, ProveedoresBean proveedores){		
		List listaProveedores = null;
		switch (tipoLista) {
		case Enum_Lis_Proveedores.alfanumerica:		
			listaProveedores=  proveedoresDAO.listaAlfanumerica(proveedores, Enum_Lis_Proveedores.alfanumerica);				
			break;					
		}		
		return listaProveedores;
	}
	
	public  Object[] listaCombo(int tipoLista,ProveedoresBean proveedores ) {
		
		List listaTiposCtas = null;
		
		switch(tipoLista){
			
			case (Enum_Lis_Proveedores.tipoTercero): 
				listaTiposCtas =  proveedoresDAO.listaTipoTercero(tipoLista);
				break;
			case (Enum_Lis_Proveedores.tipoOperacion): 
				listaTiposCtas =  proveedoresDAO.listaTipoOperacion(proveedores, tipoLista);
				break;
			
		}
		
		return listaTiposCtas.toArray();		
	}



	public List DetalleGrid(ProveedoresBean proveedoresBean){

		List<String> sucursales   = proveedoresBean.getListaSucursales();

		ArrayList listaDetalle = new ArrayList();
		ProveedoresBean proveTipoGastoBean = null;

		if(sucursales!=null){

			int tamanio = sucursales.size();

			for(int i=0; i<tamanio; i++){

				if(!sucursales.get(i).equals("0")){
					proveTipoGastoBean = new ProveedoresBean();

					proveTipoGastoBean.setTipoGastoID(proveedoresBean.getTipoGastoID());
					proveTipoGastoBean.setSucursal(sucursales.get(i));
					proveTipoGastoBean.setProveedorID(proveedoresBean.getProveedorID());
					listaDetalle.add(proveTipoGastoBean);
				}
			}
		}
		return listaDetalle;
	}



	public void setProveedoresDAO(ProveedoresDAO proveedoresDAO) {
		this.proveedoresDAO = proveedoresDAO;
	}

	public ProveedoresDAO getproveedoresDAO() {
		return proveedoresDAO;
	}





}
