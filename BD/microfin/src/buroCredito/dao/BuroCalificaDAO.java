package buroCredito.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import buroCredito.bean.BuroCalificaBean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class BuroCalificaDAO extends BaseDAO{

	
	@SuppressWarnings("unchecked")
	public List<BuroCalificaBean> listaBuroCalifica(BuroCalificaBean buroCalificaBean, int tipoLista){
		List listaBuroCalificaBean = null;
		try{
			transaccionDAO.generaNumeroTransaccion();
			
			long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
			
			String query = "call BUROCALIFICAREP(?,?,?,?,?,		?,?,?,?,?,	?,?)";

			Object[] parametros ={
								buroCalificaBean.getTipoCartera(),
								buroCalificaBean.getRangoCartera(),
								Utileria.convierteFecha(buroCalificaBean.getPeriodo()),
								buroCalificaBean.getEstatusCredito(),
								numeroTransaccion,
								
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"BuroCalificaDAO.listaBuroCalifica",

								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BUROCALIFICAREP(" + Arrays.toString(parametros) +")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					BuroCalificaBean buroCalifica = new BuroCalificaBean();
					
					buroCalifica.setReferenciaConsultado(resultSet.getString("ClienteID"));
					buroCalifica.setTipoCliente(resultSet.getString("TipoPersona"));
					buroCalifica.setRfc(resultSet.getString("RFCOficial"));
					buroCalifica.setNombre(resultSet.getString("PrimerNombre"));
					buroCalifica.setSegundoNombre(resultSet.getString("SegundoNombre"));
					buroCalifica.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
					buroCalifica.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
					buroCalifica.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
					buroCalifica.setCurp(resultSet.getString("CURP"));
					buroCalifica.setCalleNum(resultSet.getString("Direccion"));
					buroCalifica.setCalleNumDOS(resultSet.getString("DireccionDOS"));
					buroCalifica.setColonia(resultSet.getString("Colonia"));
					buroCalifica.setMunicipio(resultSet.getString("Municipio"));
					buroCalifica.setCiudad(resultSet.getString("Ciudad"));
					buroCalifica.setEstado(resultSet.getString("Estado"));
					buroCalifica.setCodigoPostal(resultSet.getString("CodigoPostal"));
					buroCalifica.setPaisOrigen(resultSet.getString("PaisNombre"));
					buroCalifica.setReferenciaCrediticia(resultSet.getString("CreditoID"));
					
					return buroCalifica;
				}
			});
			listaBuroCalificaBean = matches;
			
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.info("Error en la lista de Buro Califica - BuroCalificaDAO.listaBuroCalifica ");
		}
		
		return listaBuroCalificaBean;
	}
}
