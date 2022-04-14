package cliente.dao;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.FlujoPantallaClienteBean;

public class FlujoPantallaClienteDAO extends BaseDAO{
	
	public FlujoPantallaClienteDAO() {
		super();
	}
	
	ParametrosSesionBean parametrosSesionBean;
	ParametrosAuditoriaBean parametrosAuditoriaBean;
	private final static String salidaPantalla = "S";
	// ------------------ Transacciones ------------------------------------------


	/* Lista de pantallas según el flujo*/
	public List<FlujoPantallaClienteBean> listaCliente(FlujoPantallaClienteBean flujoPantallaClienteBean) {
		//Query con el Store Procedure
		String query = "call FLUJOSPANTALLALIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	flujoPantallaClienteBean.getTipoFlujoID(),
								flujoPantallaClienteBean.getIdentificador(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FLUJOSPANTALLALIS(" + Arrays.toString(parametros) + ")");
		List<FlujoPantallaClienteBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosSesionBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FlujoPantallaClienteBean flujoPantallaCliente = new FlujoPantallaClienteBean();			
				flujoPantallaCliente.setOrden(resultSet.getInt("Orden"));
				flujoPantallaCliente.setRecurso(resultSet.getString("Recurso"));
				flujoPantallaCliente.setDesplegado(resultSet.getString("Desplegado"));
				return flujoPantallaCliente;				
			}
		});
		
		
		FlujoPantallaClienteBean flujoPantalla = null;
		FlujoPantallaClienteBean flujoPantallaIter = null;
		List<FlujoPantallaClienteBean> matches2 = new ArrayList<FlujoPantallaClienteBean>();
		Locale currentLocale;
		ResourceBundle messages;
		Iterator<FlujoPantallaClienteBean> itera = null; 
		
		currentLocale = new Locale(flujoPantallaClienteBean.getNomCortoInstitucion());
		
        messages = ResourceBundle.getBundle("messages", currentLocale);
		
		
		
		itera = matches.iterator();
		while(itera.hasNext()){
			flujoPantalla = new  FlujoPantallaClienteBean();
			flujoPantallaIter = itera.next();
			flujoPantalla.setOrden(flujoPantallaIter.getOrden());
			flujoPantalla.setRecurso(flujoPantallaIter.getRecurso());
			try{
				flujoPantalla.setDesplegado(messages.getString(flujoPantallaIter.getDesplegado()));
			}catch(MissingResourceException e){
				flujoPantalla.setDesplegado(flujoPantallaIter.getDesplegado());
			}
			matches2.add(flujoPantalla);
		}
		return matches2;
		
	}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}


	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
	
}
