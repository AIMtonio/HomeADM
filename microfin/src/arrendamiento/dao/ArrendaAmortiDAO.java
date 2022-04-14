package arrendamiento.dao;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import arrendamiento.bean.ArrendaAmortiBean;
import arrendamiento.bean.ArrendamientosBean;

public class ArrendaAmortiDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	
	public ArrendaAmortiDAO(){
		super();
	}
	/*Consulta para generales de arrendamiento */
	public ArrendaAmortiBean consultaArrendaAmorti(ArrendaAmortiBean arrendaAmortiBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ARRENDAAMORTICON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	
				arrendaAmortiBean.getArrendaID(),	
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ArrendaAmortiDAO.consultaArrendaAmorti",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAAMORTICON(  " + Arrays.toString(parametros) + ")");
		List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ArrendaAmortiBean arrendaAmortiBean = new ArrendaAmortiBean();
				try{
					arrendaAmortiBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigent"));
					arrendaAmortiBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
					arrendaAmortiBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					arrendaAmortiBean.setSaldoInteresVigente(resultSet.getString("SaldoInteresVigente"));
					arrendaAmortiBean.setSaldoInteresAtras(resultSet.getString("SaldoInteresAtras"));
					arrendaAmortiBean.setSaldoInteresVen(resultSet.getString("SaldoInteresVen"));
					arrendaAmortiBean.setMontoIVACapital(resultSet.getString("MontoIVACapital"));
					arrendaAmortiBean.setMontoIVAComFalPag(resultSet.getString("MontoIVAComFalPag"));
					arrendaAmortiBean.setMontoIVAComisi(resultSet.getString("MontoIVAComisi"));
					arrendaAmortiBean.setMontoIVAInteres(resultSet.getString("MontoIVAInteres"));
					arrendaAmortiBean.setMontoIVAMora(resultSet.getString("MontoIVAMora"));
					arrendaAmortiBean.setMontoIVASeguroVida(resultSet.getString("MontoIVASeguroVida"));
					arrendaAmortiBean.setSaldoSeguro(resultSet.getString("SaldoSeguro"));
					arrendaAmortiBean.setMontoIVASeguro(resultSet.getString("MontoIVASeguro"));
					arrendaAmortiBean.setSaldoSeguroVida(resultSet.getString("SaldoSeguroVida"));
					arrendaAmortiBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					arrendaAmortiBean.setSaldComFaltPago(resultSet.getString("SaldComFaltPago"));
					arrendaAmortiBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
					arrendaAmortiBean.setTotalCapital(resultSet.getString("TotalCapital"));
					arrendaAmortiBean.setTotalInteres(resultSet.getString("TotalInteres"));
					arrendaAmortiBean.setTotalComision(resultSet.getString("TotalComision"));
					arrendaAmortiBean.setTotalIvaComisi(resultSet.getString("TotalIVACom"));
					arrendaAmortiBean.setTotalExigible(resultSet.getString("TotalExigible"));
					
				} catch(Exception ex){
					ex.printStackTrace();
				}
			    return arrendaAmortiBean;
			}
		});
		return matches.size() > 0 ? (ArrendaAmortiBean) matches.get(0) : null;
	}
	/**
	 * Lista de Amortizaciones por Id de arrendamiento (L=1)
	 * @param arrendaAmortiBean
	 * @param tipoLista
	 * @return
	 * @author vsanmiguel
	 */
	public List listaAmortisArrendamientoID(ArrendaAmortiBean arrendaAmortiBean, int tipoLista){
		List amortizaciones = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRENDAAMORTILIS(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	arrendaAmortiBean.getArrendaID(),
									tipoLista,
									
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ArrendaAmortiDAO.listaAmortisArrendamientoID",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAAMORTILIS(" + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ArrendaAmortiBean arrendaAmorti = new ArrendaAmortiBean();			
					arrendaAmorti.setArrendaID(resultSet.getString("ArrendaID"));
					arrendaAmorti.setArrendaAmortiID(resultSet.getString("ArrendaAmortiID"));
					arrendaAmorti.setFechaInicio(resultSet.getString("FechaInicio"));
					arrendaAmorti.setFechaVencim(resultSet.getString("FechaVencim"));
					arrendaAmorti.setFechaExigible(resultSet.getString("FechaExigible"));					
					arrendaAmorti.setCapitalRenta(resultSet.getString("CapitalRenta"));
					arrendaAmorti.setInteresRenta(resultSet.getString("InteresRenta"));	
					arrendaAmorti.setIvaRenta(resultSet.getString("IVARenta"));
					arrendaAmorti.setRenta(resultSet.getString("Renta"));
					arrendaAmorti.setSaldoCapital(resultSet.getString("SaldoInsoluto"));
					arrendaAmorti.setSeguro(resultSet.getString("Seguro"));	
					arrendaAmorti.setSeguroVida(resultSet.getString("SeguroVida"));	
					arrendaAmorti.setPagoTotal(resultSet.getString("PagoTotal"));
					arrendaAmorti.setEstatus(resultSet.getString("Estatus"));				
					//totales
					arrendaAmorti.setTotalCapital(resultSet.getString("TotalCapital"));
					arrendaAmorti.setTotalInteres(resultSet.getString("TotalInteres"));
					arrendaAmorti.setTotalIva(resultSet.getString("TotalIVA"));
					arrendaAmorti.setTotalRenta(resultSet.getString("TotalRenta"));
					arrendaAmorti.setTotalPago(resultSet.getString("TotalPago"));
					
					arrendaAmorti.setIvaSeguro(resultSet.getString("IVASeguro"));
					arrendaAmorti.setIvaSeguroVida(resultSet.getString("IVASeguroVida"));
					return arrendaAmorti;
				}
			});
			return amortizaciones = matches.size() > 0 ? matches: null;
			
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la lista de amortizaciones.", e);
			e.printStackTrace();			
		}
		return amortizaciones;	
	}
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
